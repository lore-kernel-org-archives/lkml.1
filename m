Return-Path: <linux-kernel-owner+w=401wt.eu-S1751611AbZH1Q6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbZH1Q6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 12:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbZH1Q6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 12:58:16 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:55118 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbZH1Q6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 12:58:15 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0908271805210.3218@localhost.localdomain>
References: <alpine.LFD.2.01.0908271805210.3218@localhost.localdomain>
Date: Fri, 28 Aug 2009 12:58:17 -0400
Message-ID: <7e0fb38c0908280958x2c680e97v36f74c6ece52cb8d@mail.gmail.com>
Subject: Re: Linux 2.6.31-rc8
From: Eric Paris <eparis@parisplace.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/27 Linus Torvalds <torvalds@linux-foundation.org>:

> So apart from the trivial but somewhat bulky stuff like that, there's a
> sparc TLB loading upddate, there's a mpt2sas driver update, and there's
> the plan9 filesystem update. And there's a few fs/notify cleanups and
> fixes that will hopefully put the inotify problems behind us for good.
> Knock wood.

Knocking on wood failed.  I actually screwed inotify up worse in -rc8
than ever before (2 new regressions including inotify never gets
events!!)

Sorry to everyone out there trying to use -rc8...

-Eric
