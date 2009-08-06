Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbZHFUOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbZHFUOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbZHFUOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:14:10 -0400
Received: from senator.holtmann.net ([87.106.208.187]:42675 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZHFUOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:14:09 -0400
Subject: Re: [PATCH 2/3] drivers/bluetooth: Add kmalloc NULL tests
From: Marcel Holtmann <marcel@holtmann.org>
To: Julia Lawall <julia@diku.dk>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0908062204290.19100@ask.diku.dk>
References: <Pine.LNX.4.64.0908062204290.19100@ask.diku.dk>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 13:14:02 -0700
Message-Id: <1249589642.21101.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

> From: Julia Lawall <julia@diku.dk>
> 
> Check that the result of kmalloc is not NULL before dereferencing it.
> The patch also replaces kmalloc + memset by kzalloc.

good that this driver is not merged upstream yet. I apply the patch to
my tree. Thanks.

Regards

Marcel


