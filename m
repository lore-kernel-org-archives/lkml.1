Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYLaOZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYLaOZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 09:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbYLaOY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 09:24:56 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51008 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbYLaOYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 09:24:55 -0500
To: Daniel Phillips <phillips@phunq.net>
Cc: Dave Chinner <david@fromorbit.com>, tux3@tux3.org,
       sniper <s3c24xx@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>
Subject: Re: [Tux3] Tux3 report: A Golden Copy
From: Andi Kleen <andi@firstfloor.org>
References: <200812301935.49303.phillips@phunq.net>
	<200812310000.55256.phillips@phunq.net>
	<20081231083123.GF10725@disturbed>
	<200812310140.49503.phillips@phunq.net>
Date: Wed, 31 Dec 2008 15:26:32 +0100
In-Reply-To: <200812310140.49503.phillips@phunq.net> (Daniel Phillips's message of "Wed, 31 Dec 2008 01:40:49 -0800")
Message-ID: <877i5gv2sn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips <phillips@phunq.net> writes:
>
> Thanks for the howto.  That was Jeff's suggestion also, but it would
> be so much slicker if it was automagic, and first-time users would not

Just provide a sample gdbrc that does all this somewhere in arch/um ? 
Then they would just have to source that file.

There used to be a similar one for kgdb which defined all sorts
of useful macros. Some of the BSDs even have their own collections 
of useful gdb macros in tree, I always thought this was a good idea. 

-Andi

-- 
ak@linux.intel.com
