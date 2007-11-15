Return-Path: <linux-kernel-owner+w=401wt.eu-S1762622AbXKOKPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762622AbXKOKPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 05:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757636AbXKOKPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 05:15:38 -0500
Received: from mail5.tpgi.com.au ([203.12.160.101]:52103 "EHLO
	mail5.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757634AbXKOKPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 05:15:37 -0500
X-TPG-Antivirus: Passed
Subject: Re: 2.6.24-rc2 panic: (non-exitent) NFS root f/s
From: Shane <ibm-main@tpg.com.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200711142242.51681.rjw@sisk.pl>
References: <1195046393.9513.19.camel@toshi>
	 <200711142242.51681.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 15 Nov 2007 20:15:11 +1000
Message-Id: <1195121711.5871.11.camel@toshi>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-14 at 22:42 +0100, Rafael J. Wysocki wrote:

> Perhaps it just can't find the root filesystem at all?

Indeed - thanks for the input.
My supposed "good" source config didn't match the running kernel. A
"work in progress" I had obviously forgotten about.

Apologies for having disturbed the list.

