Return-Path: <linux-kernel-owner+w=401wt.eu-S1765313AbXHANpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765313AbXHANpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762975AbXHANpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:45:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48645 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762897AbXHANph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:45:37 -0400
Date: Wed, 1 Aug 2007 14:45:29 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: Re: 2.6.23-rc1-mm2
Message-ID: <20070801134529.GB12456@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
	Jason Wessel <jason.wessel@windriver.com>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <20070801062501.GB7581@linux-sh.org> <8bd0f97a0708010058v76f13361q62e79fe39c1f0589@mail.gmail.com> <20070801011033.51679dd5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801011033.51679dd5.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 01:10:33AM -0700, Andrew Morton wrote:
> I was hoping for a 2.6.24 merge.  But I haven't actually looked at it yet. 
> Hopefully Jason is planning to get it all out for review soonish.

The current version is quite messy.  I'd be much happier if we could
start with a light version that doesn't have all the intrusions to random
code outside the kgdb core.

