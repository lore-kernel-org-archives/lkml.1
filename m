Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbYFDKKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbYFDKKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757112AbYFDKK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:10:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39031 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbYFDKK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:10:26 -0400
Subject: Re: [PATCH] console - Add configurable support for console charset
	translation
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Josh Boyer <jwboyer@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
       linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080604100721.GB27335@cs181133002.pp.htv.fi>
References: <48447615.5050806@am.sony.com>
	 <1212500751.16924.322.camel@pmac.infradead.org>
	 <4845DB46.3020308@am.sony.com>
	 <1212538597.4042.29.camel@shinybook.infradead.org>
	 <20080603200349.3b1957e1@vader.jdub.homelinux.org>
	 <1212541541.4042.41.camel@shinybook.infradead.org>
	 <20080603221309.5e2762be@vader.jdub.homelinux.org>
	 <1212570982.4042.64.camel@shinybook.infradead.org>
	 <20080604100721.GB27335@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 11:10:15 +0100
Message-Id: <1212574215.32207.9.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 13:07 +0300, Adrian Bunk wrote:
> On Wed, Jun 04, 2008 at 10:16:22AM +0100, David Woodhouse wrote:
> > On Tue, 2008-06-03 at 22:13 -0500, Josh Boyer wrote:
> > > 
> > > >  git.infradead.org/embedded-2.6.git
> > > 
> > > Do you have plans to get that in -mm, or linux-next?
> > 
> > Should be already there in today's linux-next.
> 
> Does this imply you want Linus to merge from this tree?

Yes.

> How does this tree fit into the usual maintainership inside the Linux 
> kernel?

Well, I was trying to avoid creating it -- because largely it doesn't.
I was hoping that everything could go upstream through other routes.
But Tim's patch really was a candidate for handling it myself (unless
I'm just going to punt everything to Andrew), so I capitulated.

-- 
dwmw2

