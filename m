Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYEISr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYEISr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 14:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYEISrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 14:47:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56222 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751142AbYEISrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 14:47:46 -0400
Date: Fri, 9 May 2008 14:47:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>, Greg KH <greg@kroah.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.6.26-rc1 regression since 2.6.25
In-Reply-To: <20080509151924.GA30644@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0805091447070.2648-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008, Greg KH wrote:

> Can you just boot the box and then plug it into the dock and show the
> log file for that?

If you can, use a kernel that has CONFIG_USB_DEBUG turned on.

Alan Stern

