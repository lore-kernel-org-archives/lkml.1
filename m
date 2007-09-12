Return-Path: <linux-kernel-owner+w=401wt.eu-S933008AbXILJ1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008AbXILJ1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 05:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763465AbXILJ1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 05:27:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54212 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760679AbXILJ1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 05:27:36 -0400
Date: Wed, 12 Sep 2007 10:27:16 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge - a little feedback
Message-ID: <20070912092716.GA32511@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	Andi Kleen <ak@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20070911201219.GA9674@uranus.ravnborg.org> <20070911203412.GS3563@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911203412.GS3563@stusta.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 10:34:13PM +0200, Adrian Bunk wrote:
> As an example, visws.c is as much non-64bit as it is pre-i686.

Bullshit.  visws were shipped with P3s.

