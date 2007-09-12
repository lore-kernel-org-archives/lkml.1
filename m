Return-Path: <linux-kernel-owner+w=401wt.eu-S968162AbXILNt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968162AbXILNt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 09:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966044AbXILNtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 09:49:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46390 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965695AbXILNtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 09:49:20 -0400
Date: Wed, 12 Sep 2007 14:49:10 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Neuling <mikey@neuling.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, paulus@samba.org,
       Alan Cox <alan@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] powerpc: add new required termio functions
Message-ID: <20070912134910.GA12660@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michael Neuling <mikey@neuling.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, paulus@samba.org,
	Alan Cox <alan@redhat.com>, "David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <8018.1189562679@neuling.org> <20070912102032.GB7858@osiris.boeblingen.de.ibm.com> <20070912040109.3f6a9149.akpm@linux-foundation.org> <20070912113409.GA7253@infradead.org> <20070912115257.GC7858@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912115257.GC7858@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 01:52:57PM +0200, Heiko Carstens wrote:
> > I might be missing something, but the the right fix is probably to
> > apply the arch patches from Alan to powerpc and s390.  We don't want to
> > be left over without all the nice termios features on these platforms,
> > do we?
> 
> But not in rc6 timeframe, I would guess?

Ask Alan..
