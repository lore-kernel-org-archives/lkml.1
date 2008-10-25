Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191AbYJYTu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbYJYTu1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 15:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYJYTuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 15:50:10 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3202 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750928AbYJYTuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 15:50:09 -0400
Date: Sat, 25 Oct 2008 15:50:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Luciano Rocha <luciano@eurotux.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: usb hdd problems with 2.6.27.2
In-Reply-To: <200810252125.44184.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0810251548300.7245-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008, Rafael J. Wysocki wrote:

> [Adding CCs]
> 
> On Wednesday, 22 of October 2008, Luciano Rocha wrote:
> > 
> > Hello,
> > 
> > An external HDD, usb-encased, works fine under 2.6.26.5, but under
> > 2.6.27.2 I get hundreds of errors per second, of 'No Sense [current]'.

You can use usbmon to capture the details of what happens when you plug
in the drive.  Instructions are in the kernel source file
Documentation/usb/usbmon.txt.

Alan Stern

