Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbYAUHqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbYAUHqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 02:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbYAUHqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 02:46:01 -0500
Received: from pip15.gyao.ne.jp ([61.122.117.253]:28362 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755413AbYAUHqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 02:46:00 -0500
Date: Mon, 21 Jan 2008 16:45:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, matsu@igel.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: Why not creating a GIT RT tree ?
Message-ID: <20080121074524.GA20072@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Francis Moreau <francis.moro@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>, matsu@igel.co.jp,
	linux-kernel@vger.kernel.org
References: <38b2ab8a0801180544j2022af8bl252a118a295b1f34@mail.gmail.com> <Pine.LNX.4.58.0801180947180.7574@gandalf.stny.rr.com> <38b2ab8a0801180937y4264fc15wd3b91ca74635f679@mail.gmail.com> <Pine.LNX.4.58.0801181400110.10928@gandalf.stny.rr.com> <38b2ab8a0801191141g31137fe5m3b5fff35499588e5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38b2ab8a0801191141g31137fe5m3b5fff35499588e5@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2008 at 08:41:18PM +0100, Francis Moreau wrote:
> On Jan 18, 2008 8:12 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > True, but then how would you do it. One thing is that most of these
> > branches would interact with each other. Touching the same code quite
> > a bit. So it doesn't always help. But pulling out patches can help us to
> > an extent.
> >
> 
> I see, it would probably be too painful in this context, that's pity.
> 
> >
> > Great! Looking forward to it ;-)
> >
> 
> Well actually it seems already supported. Some files in arch/sh
> are already touched by RT patches.
> 
At least it sees fairly regular testing on SH7751R and SH7780, you may
wish to discuss this with Matsubara-san (added to CC) though, as he does
most of the work in this area. I don't get much time to look at it.
