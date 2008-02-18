Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbYBRPMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbYBRPMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbYBRPLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:11:53 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:57737 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752937AbYBRPLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:11:52 -0500
Date: Mon, 18 Feb 2008 10:11:19 -0500
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>, Andreas Dilger <adilger@sun.com>,
       sct@redhat.com, akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/jbd/journal.c: cleanups
Message-ID: <20080218151119.GC25098@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Adrian Bunk <bunk@kernel.org>, Andreas Dilger <adilger@sun.com>,
	sct@redhat.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080217081935.GN3848@cs181133002.pp.htv.fi> <20080218070439.GG3029@webber.adilger.int> <20080218071229.GA1459@elte.hu> <20080218114936.GM8905@mit.edu> <20080218131209.GB21080@cs181133002.pp.htv.fi> <20080218133140.GA21635@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218133140.GA21635@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 02:31:40PM +0100, Ingo Molnar wrote:
> i guess this explains what static code metrics already suggest:

Am I right in assuming that code-quality is just a program which runs
checkpatch.pl and measures the number of warnings and calls them
errors?

					- Ted
