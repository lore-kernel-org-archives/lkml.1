Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbXJMMMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbXJMMMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 08:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbXJMMMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 08:12:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48861 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbXJMMMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 08:12:38 -0400
Date: Sat, 13 Oct 2007 12:32:22 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Correct filenames in comments.
Message-ID: <20071013113222.GB11464@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20071013004332.GA18760@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071013004332.GA18760@redhat.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 08:43:32PM -0400, Dave Jones wrote:
> I never really understood the motivation behind putting the filename
> in a comment, but this fixes up a bunch of them that are now wrong
> post-merge.

Please just remove all these useless filename comments.

