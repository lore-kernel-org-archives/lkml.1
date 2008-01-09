Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbYAIB3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbYAIB3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbYAIB2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:28:52 -0500
Received: from 1wt.eu ([62.212.114.60]:1225 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbYAIB2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:28:52 -0500
Date: Wed, 9 Jan 2008 02:17:06 +0100
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc7
Message-ID: <20080109011706.GA8953@1wt.eu>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 02:19:16PM -0800, Linus Torvalds wrote:
> Both git trees and tar-balls/patches pushed out, should be mirroring out 
> within minutes. So there are no excuses to not try it out, and see if your 
> favorite regression has been fixed.

At first glance, looks fine and fast here on dual-athlon XP desktop with
adaptec SCSI, NFS, e1000 and SBLive. All the comments here did not look
encouraging, but I'll let it run as long as possible there since I
encountered no build nor boot error.

Cheers,
Willy

