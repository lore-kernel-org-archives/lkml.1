Return-Path: <linux-kernel-owner+w=401wt.eu-S1751382AbXEXOSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbXEXOSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbXEXOSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:18:47 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2566 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750738AbXEXOSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:18:46 -0400
Date: Thu, 24 May 2007 10:18:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [linux-pm] Re: [2/3] 2.6.22-rc2: known regressions v2
In-Reply-To: <46559B54.80106@googlemail.com>
Message-ID: <Pine.LNX.4.44L0.0705241013590.5935-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, Michal Piotrowski wrote:

> Suspend
> 
> Subject    : STD fails with pci_device_suspend(): usb_hcd_pci_suspend+0x0/0x160 [usbcore]() returns -16
> References : http://lkml.org/lkml/2007/5/19/66
> Submitter  : Andrey Borzenkov <arvidjaar@mail.ru>
> Status     : Unknown

This has been fixed and the patches are in the current -git.

Alan Stern

