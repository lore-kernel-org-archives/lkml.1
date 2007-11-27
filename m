Return-Path: <linux-kernel-owner+w=401wt.eu-S1760324AbXK0XUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324AbXK0XUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbXK0XUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:20:47 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:53388 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbXK0XUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:20:47 -0500
Date: Wed, 28 Nov 2007 00:20:46 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Tilman Schmidt <tilman@imap.cc>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: git guidance
In-Reply-To: <474C9B31.8000408@imap.cc>
Message-ID: <Pine.LNX.4.64.0711280019200.4181@fbirervta.pbzchgretzou.qr>
References: <474C9B31.8000408@imap.cc>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 27 2007 23:33, Tilman Schmidt wrote:
>
>It didn't work too well. The first result was one of maximal
>embarrassment: I produced a patch that didn't even compile when
>applied to the official tree. This shouldn't happen with git, right?
>Well, it did. So now I'm back to keeping a virgin kernel source tree
>alongside my development area in order to produce diffs. That can't
>be right?
>
No, it can't. Use stgit/quilt ;p

>Does somebody have a step by step tutorial for doing the standard
>"edit - test - modify - retest - submit - edit - resubmit" sequence
>with GIT? Is there a GIT newsgroup or mailinglist? Or should I just
>post my silly questions to LKML?
>
http://www.linuxworld.com/video/?bcpid=1138309735&bclid=1213841149&bctid=1221911905

James Bottomley's intro helps a lot.
