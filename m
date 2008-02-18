Return-Path: <linux-kernel-owner+w=401wt.eu-S1760856AbYBRNcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760856AbYBRNcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760607AbYBRNbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:31:52 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37058 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760471AbYBRNbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:31:50 -0500
Date: Mon, 18 Feb 2008 08:31:28 -0500
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andreas Dilger <adilger@sun.com>, Adrian Bunk <bunk@kernel.org>,
       sct@redhat.com, akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/jbd/journal.c: cleanups
Message-ID: <20080218133127.GB12568@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Andreas Dilger <adilger@sun.com>, Adrian Bunk <bunk@kernel.org>,
	sct@redhat.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080217081935.GN3848@cs181133002.pp.htv.fi> <20080218070439.GG3029@webber.adilger.int> <20080218071229.GA1459@elte.hu> <20080218114936.GM8905@mit.edu> <20080218125702.GB15044@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218125702.GB15044@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So please deal with it like most other subsystem maintainers do and stop 
> complaining about "code churn" - nobody but you changes the ext3 
> codebase, it's one of the codebases least affected by general kernel 
> flux, it's an ultimate "leaf" subsystem.

Right, sorry.  I misread the filename; I thought this was against
fs/jbd2, instead of fs/jbd.

						- Ted
