Return-Path: <linux-kernel-owner+w=401wt.eu-S967276AbXILMqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967276AbXILMqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 08:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966136AbXILMpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 08:45:53 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:54938 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967190AbXILMpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 08:45:52 -0400
Date: Wed, 12 Sep 2007 08:45:51 -0400
To: Christoph Hellwig <hch@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge - a little feedback
Message-ID: <20070912124551.GA5386@csclub.uwaterloo.ca>
References: <20070911201219.GA9674@uranus.ravnborg.org> <20070911203412.GS3563@stusta.de> <20070912092716.GA32511@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912092716.GA32511@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 10:27:16AM +0100, Christoph Hellwig wrote:
> On Tue, Sep 11, 2007 at 10:34:13PM +0200, Adrian Bunk wrote:
> > As an example, visws.c is as much non-64bit as it is pre-i686.
> 
> Bullshit.  visws were shipped with P3s.

Certainly true, but still not 64bit and never will be.

--
Len Sorensen
