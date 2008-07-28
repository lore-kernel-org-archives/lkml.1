Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbYG1QNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbYG1QNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbYG1QM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:12:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:34183 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbYG1QM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:12:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NtqqzeU2bOhR31ZiWFB5oyH5ZNe3BmNyGrkGnxU2F3a2JYYnlCsX5QXKCTAQD+h2KF
         JhBP+HKJ+RJaQjTtfOxTL62YHWE2aeriozHlfSq1SElVzPnsjJheC0MetTu42NmX/3/W
         5KYfGXYMohJheapyizMGlk+MrSXx92x+GXMl4=
Message-ID: <9e4733910807280912r5a30d951u3cfd4ca95c12c850@mail.gmail.com>
Date: Mon, 28 Jul 2008 12:12:56 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: 463 kernel developers missing!
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <9e4733910807280858s243d02b8hb4732bcae1e8f4d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com>
	 <9e4733910807280820v118b728fu1c0a8b8eb4c4fdaa@mail.gmail.com>
	 <20080728153546.GD30612@cs181140183.pp.htv.fi>
	 <9e4733910807280845y7e07486n84794a6e74cb59c2@mail.gmail.com>
	 <20080728155227.GF30612@cs181140183.pp.htv.fi>
	 <9e4733910807280858s243d02b8hb4732bcae1e8f4d3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew was getting credit for Len Brown's patches, new top 20.

Of course the list has errors in it, but they are easy to find and
fix. Once they are fixed they will never change since they reflect the
existing history in the tree.

Let's get the main patch in and then everyone can send in little
patches to fix the errors. I've removed all of the errors I can via
scripts, now it is a manual process to spot the aliases.

Linus Torvalds (4350):
David S. Miller (1858):
Adrian Bunk (1774):
Al Viro (1735):
Ingo Molnar (1393):
Ralf Baechle (1367):
Jeff Garzik (1291):
Andrew Morton (1280):
Takashi Iwai (1196):
Tejun Heo (1092):
Bartlomiej Zolnierkiewicz (1071):
Patrick McHardy (1031):
Stephen Hemminger (1017):
Russell King (985):
Andi Kleen (973):
Thomas Gleixner (953):
Alan Cox (822):
Paul Mundt (813):
Jean Delvare (771):


-- 
Jon Smirl
jonsmirl@gmail.com
