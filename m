Return-Path: <linux-kernel-owner+w=401wt.eu-S1759836AbZAVX0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836AbZAVX0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbZAVXZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:25:55 -0500
Received: from matrixpower.ru ([195.178.208.66]:54898 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759525AbZAVXZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:25:54 -0500
Date: Fri, 23 Jan 2009 02:25:52 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Greg KH <gregkh@suse.de>
Cc: kyle@infradead.org, Dave Jones <davej@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>, J?rn Engel <joern@logfs.org>,
       David Brown <lkml@davidb.org>, Phil Oester <kernel@linuxace.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090122232552.GB5656@ioremap.net>
References: <20090110165033.GA23943@logfs.org> <20090110101235.7ca24c44.akpm@linux-foundation.org> <20090110221528.GA31774@elte.hu> <Pine.LNX.4.64.0901111022590.30201@anakin> <20090111153920.GC7401@elte.hu> <20090111163018.GA9300@suse.de> <20090122215041.GA29369@redhat.com> <20090122215817.GA27609@suse.de> <20090122225025.GA21879@bombadil.infradead.org> <20090122230457.GA24745@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122230457.GA24745@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 03:04:57PM -0800, Greg KH (gregkh@suse.de) wrote:
> > (I also think TAINT_CRAP is kind of an insulting name for things which
> > are really Linux-targetted features that just haven't had thorough
> > enough review. Evgeniy Polyakov's work comes to mind... it's really
> > comparing apples to a bunch of festering pieces of turd.
> 
> It was his choice to put the code into there, I'll let him handle the
> mental issues of having that taint flag associated with it for a few
> releases :)

If you could know haw bad is my sleep since then...

-- 
	Evgeniy Polyakov
