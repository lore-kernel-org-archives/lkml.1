Return-Path: <linux-kernel-owner+w=401wt.eu-S1762835AbYBMKYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762835AbYBMKYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 05:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbYBMKYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 05:24:41 -0500
Received: from 1wt.eu ([62.212.114.60]:1894 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbYBMKYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 05:24:41 -0500
Date: Wed, 13 Feb 2008 11:24:36 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ferenc Wagner <wferi@niif.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: currently active Linux kernel versions
Message-ID: <20080213102436.GA3580@1wt.eu>
References: <47B21F9A.8040904@wpkg.org> <20080213004951.GA29524@1wt.eu> <87k5l9pb7d.fsf@szonett.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k5l9pb7d.fsf@szonett.ki.iif.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 08:28:06AM +0100, Ferenc Wagner wrote:
> Willy Tarreau <w@1wt.eu> writes:
> 
> > I would suggest stable - N-1 for most usages. 2.6.24.y is open, 2.6.23.y is
> > supposed to be good. The advantage when you proceed like this is that you
> > can jump from an older kernel to a more recent one which has already got its
> > share of fixes and is still maintained for some time.
> >
> > Generally, I would trust Greg when he drops an old kernel, it means that he's
> > confident enough in the next one.
> 
> Thanks for the useful (and concise) summary and sharing your thoughts
> on the matter.  Now my only question is: how can I learn that Greg
> updated or dropped a kernel without following LKML (which my time
> unfortunately does not permit).  kernel-announce doesn't seem to
> mention such events...

Compare the release dates. If you see the latest 2.6.23.y released a week
ago and nothing equivalent for 2.6.22.y, chances are that there will not
be newer ones. Also, Greg announces his intentions to stop in each announce.
Last he stated that 2.6.22.17 (and finally 18) was most likely the last one.

Willy

