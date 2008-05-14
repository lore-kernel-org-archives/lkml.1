Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbYENU7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbYENU7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbYENU7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:59:00 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52039 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbYENU7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:59:00 -0400
Date: Wed, 14 May 2008 14:58:42 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
Message-ID: <20080514205842.GC9921@parisc-linux.org>
References: <20080510030831.796641881@sgi.com> <20080510030919.604216074@sgi.com> <4825709A.2020407@firstfloor.org> <20080510221515.3540a6cc@bree.surriel.com> <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com> <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com> <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com> <482B2617.5010605@firstfloor.org> <Pine.LNX.4.64.0805141104260.15633@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0805141333550.18231@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805141333550.18231@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 01:46:52PM -0700, Christoph Lameter wrote:
> Some more on SMP scaling:

These are all great theories, and you mentioned that you'd fixed the
regressions with tbench, but did you fix the regression with the io-gen
program I sent you?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
