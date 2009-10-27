Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbZJ0CMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbZJ0CMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 22:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZJ0CMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 22:12:48 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:38978 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbZJ0CMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 22:12:48 -0400
Date: Mon, 26 Oct 2009 19:13:50 -0700
From: Ralf Baechle <ralf@linux-mips.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: wuzhangjin@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       alex@digriz.org.uk, ithamar.adema@team-embedded.nl,
       linux-mips <linux-mips@linux-mips.org>
Subject: Re: What ever happened to: [PATCH] MIPS: add support for
	gzip/bzip2/lzma compressed kernel images
Message-ID: <20091027021350.GB4451@linux-mips.org>
References: <1256606966.26028.364.camel@gandalf.stny.rr.com> <1256607468.5499.7.camel@falcon> <1256608033.26028.365.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256608033.26028.365.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 09:47:13PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Mon, 26 Oct 2009 21:47:13 -0400
> To: wuzhangjin@gmail.com
> Cc: LKML <linux-kernel@vger.kernel.org>, ralf@linux-mips.org,
> 	alex@digriz.org.uk, ithamar.adema@team-embedded.nl,
> 	linux-mips <linux-mips@linux-mips.org>
> Subject: Re: What ever happened to: [PATCH] MIPS: add support for
> 	gzip/bzip2/lzma compressed kernel images
> Content-Type: text/plain
> 
> On Tue, 2009-10-27 at 09:37 +0800, Wu Zhangjin wrote:
> 
> > Ralf have added this to his -queue git repo:
> > 
> > http://www.linux-mips.org/git?p=linux-queue.git;a=commit;h=9d20b1ddf20c3ead5e381a1d06471c33d7f3cb6d
> 
> Ah, I was looking at Ralf's kernel.org repo.
> 
> Ralf,
> 
> Which is the main repo? The one Wu shows above?

Wu's URL is the linux-queue repo which contains the stuff that will go
into the next -rc0 MIPS kernel.  This -queue repo is not replicated to
kernel.org.

The main repo is

   http://www.linux-mips.org/git?p=linux.git;a=summary

which I'm replicating to kernel.org.

  Ralf
