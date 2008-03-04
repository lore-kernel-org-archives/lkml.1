Return-Path: <linux-kernel-owner+w=401wt.eu-S1760822AbYCDRwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822AbYCDRwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYCDRwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:52:11 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:50456 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752507AbYCDRwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:52:10 -0500
Date: Tue, 4 Mar 2008 12:52:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dirk Eibach <eibach@gdsys.de>
cc: greg@kroah.com, <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <apw@shadowen.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: add sysfs configuration interface for CP2101
In-Reply-To: <47CCF42F.3090306@gdsys.de>
Message-ID: <Pine.LNX.4.44L0.0803041250470.15190-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, Dirk Eibach wrote:

> On the other hand it would a little bit sad, if Silabs windows tool
> would stay the only way to setup for all other people. I cannot see
> how I could spread the userspace tool the way it would be spread if
> it was in the kernel.  Maybe someone has an idea on that.

Maybe you shouldn't try to spread your userspace tool as widely as the 
kernel.  After all, most kernel users don't have a CP2101.

If you put the tool on a web site, people who need it will be able to 
find it using Google.

Alan Stern

