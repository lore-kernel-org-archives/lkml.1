Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYELM3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYELM3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 08:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbYELM3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 08:29:11 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52550 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755294AbYELM3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 08:29:08 -0400
Date: Mon, 12 May 2008 08:28:57 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Possible regression?  2.6.26-rc1: X61s failure after
	suspend/resume
Message-ID: <20080512122857.GD7687@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
	Jesse Barnes <jbarnes@virtuousgeek.org>
References: <E1JuCBA-0002NZ-4E@closure.thunk.org> <200805082352.04352.rjw@sisk.pl> <20080509024426.GB8871@mit.edu> <20080509094941.GA19617@elte.hu> <20080512020301.GA8390@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512020301.GA8390@mit.edu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 10:03:01PM -0400, Theodore Tso wrote:
> On Fri, May 09, 2008 at 11:49:41AM +0200, Ingo Molnar wrote:
> > 
> > on the off chance that this might be related: could you try to boot with 
> > nopat?

Hey Ingo, which bug/regression did you think my issue might be related
to?  I just looked up Kernel Bug #10620, which is what I had assumed
(from context) you were referring to, but looking at the bug, it
doesn't mention anything about nopat at all.

In any case, I'm doing some more testing to see if nopat really makes
the problem harder to recur...

						- Ted
