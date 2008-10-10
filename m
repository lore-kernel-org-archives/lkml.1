Return-Path: <linux-kernel-owner+w=401wt.eu-S1762602AbYJJQ6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762602AbYJJQ6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759869AbYJJQ6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:58:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51021 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758926AbYJJQ6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:58:33 -0400
Date: Fri, 10 Oct 2008 12:58:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Parag Warudkar <parag.lkml@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] WARNING: at kernel/power/main.c:176
 suspend_test_finish+0x70/0x80()
In-Reply-To: <f7848160810100923j12c03769x1a05ed7091e67a1b@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0810101257030.2185-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008, Parag Warudkar wrote:

> On Fri, Oct 10, 2008 at 10:31 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > There's a bug that affects USB power management: commmit
> > f9dd45ce10a014bdfd5432828c44630ea7fefedd needs to be reverted.  Greg KH
> > has been asked to do this a few times but he hasn't gotten around to it
> > yet.
> 
> Hi Alan,
> 
> Thanks for the info.
> 
> I can't seem to find that commit in mainline. If you have pointer to
> the patch I will submit a revert.

It isn't in mainline; it's in linux-next.  Sorry, I wasn't sure which 
kernel you were using.

Alan Stern

