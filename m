Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYKBClj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYKBClj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 22:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYKBCl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 22:41:29 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3881 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752630AbYKBCl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 22:41:28 -0400
Date: Sat, 1 Nov 2008 22:41:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kasper Sandberg <lkml@metanurb.dk>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: 2.6.27.2 USB reset/IO Error problem when high load on ICH9 USB
In-Reply-To: <20081031234823.5064dd88.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0811012239290.30060-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008, Andrew Morton wrote:

> (cc linux-usb)
> 
> On Thu, 30 Oct 2008 06:22:49 +0100 Kasper Sandberg <lkml@metanurb.dk> wrote:
> 
> > Hello..
> > 
> > I had to write an image to some usb flash drives, more specifically, 4GB
> > kingston datatraveler sticks, and i figured, instead of doing just 1 at
> > a time, i may aswell do 4, so i plugged in 4, and started 4 dd's of the
> > images, to sdc, sdd, sde, sdf. However, i got usb disconnects and IO
> > error messages from the kernel, these are at end of message. I had
> > previously done ~5 writes of images to 5 other flash disks with no
> > problem, but when i tried the next batch, those 4, it gave these errors.
> > I killed the dd's, pulled them all out, and put in 1 at a time, and it
> > worked perfectly.

Sounds like a hardware problem.

Alan Stern

