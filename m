Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbYBYR6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbYBYR6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbYBYR6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:58:33 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40920 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753557AbYBYR6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:58:32 -0500
Date: Mon, 25 Feb 2008 12:58:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card
 is inserted]
In-Reply-To: <20080225184102.0a2e2bb5@mjolnir.drzeus.cx>
Message-ID: <Pine.LNX.4.44L0.0802251255000.5039-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the explanations.

On Mon, 25 Feb 2008, Pierre Ossman wrote:

> Trying to keep up with the PM changes is a full time job. For now I've
> mostly ignored it as I don't even have time for the other stuff.
> Patches welcome.

What do you think of the patch attached to comment #40 in the Bugzilla 
entry?

Alan Stern

