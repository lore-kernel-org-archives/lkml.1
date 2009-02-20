Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbZBTTtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbZBTTtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 14:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZBTTsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 14:48:51 -0500
Received: from senator.holtmann.net ([87.106.208.187]:46390 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbZBTTsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 14:48:50 -0500
Subject: Re: [PATCH] bluetooth: move back hci_conn_del_sysfs to
 hci_conn_del avoid device destruct too early
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org
In-Reply-To: <499EA5F6.2060206@gmail.com>
References: <499EA5F6.2060206@gmail.com>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 20:48:59 +0100
Message-Id: <1235159339.24255.3.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> The following commit introduce a regression:
> 
> 	commit 7d0db0a373195385a2e0b19d1f5e4b186fdcffac
> 	Author: Marcel Holtmann <marcel@holtmann.org>
> 	Date:   Mon Jul 14 20:13:51 2008 +0200
> 
> 		[Bluetooth] Use a more unique bus name for connections
> 
> I get panic as following (by netconsole):

can you please send a version against my bluetooth-testing.git tree.

Regards

Marcel


