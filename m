Return-Path: <linux-kernel-owner+w=401wt.eu-S932089AbYBZV6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbYBZV6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763552AbYBZV6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:58:14 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:50143 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763359AbYBZV6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:58:13 -0500
Date: Tue, 26 Feb 2008 16:58:12 -0500
To: Jiri Kosina <jkosina@suse.cz>
Cc: Chris Holvenstot <cholvenstot@comcast.net>, elendil@planet.nl,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
Message-ID: <20080226215812.GX1287@csclub.uwaterloo.ca>
References: <1203123219.6176.36.camel@popeye> <Pine.LNX.4.64.0802161202430.7699@twin.jikos.cz> <1203163503.6124.5.camel@popeye> <Pine.LNX.4.64.0802161907200.30955@jikos.suse.cz> <1203221372.6124.29.camel@popeye> <Pine.LNX.4.64.0802211036580.30955@jikos.suse.cz> <1203587101.27355.4.camel@popeye> <20080226145832.GA1289@csclub.uwaterloo.ca> <Pine.LNX.4.64.0802261602030.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802261602030.30955@jikos.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 04:05:36PM +0100, Jiri Kosina wrote:
> This could be caused by the fact that as far as I know, X are not using 
> kernel-autorepeat, but they are handling it themselves, right? So if their 
> sense of time (probably due to some change of kernel timekeeping) gets 
> wrong, the autorepeat in X might also get wrong.
> 
> It would be nice to know if when you hit the situation when autorepeat 
> goes strange in X, if it is still OK in console.

Yes console is always fine.

--
Len Sorensen
