Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbXGIFBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbXGIFBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 01:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbXGIFBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 01:01:09 -0400
Received: from 1wt.eu ([62.212.114.60]:3318 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbXGIFBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 01:01:08 -0400
Date: Mon, 9 Jul 2007 07:00:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
Message-ID: <20070709050050.GC943@1wt.eu>
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 04:52:52PM -0700, Linus Torvalds wrote:
> Anybody? Should I make just the shortlogs available instead (I don't save 
> those, but I post those for the later -rc's - usually the -rc1 and -rc2's 
> are too big for the mailing list, but they are still a lot smaller and 
> more readable than the *full* logs are)?
> 
> Or do people really want the full logs, and don't use git?

The changelogs would be more useful if they were indexed by google, but
it seems they aren't (maybe too big, since 2.4 and 2.6.16 changelogs are
indexed ?). At least having the shortlog available would be a minimum,
provided that we try to keep the most possible descriptive subjects.
This also means being more transparent about security fixes.

Willy

