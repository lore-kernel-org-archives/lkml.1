Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbXF3KJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbXF3KJf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 06:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbXF3KJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 06:09:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56878 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbXF3KJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 06:09:25 -0400
Date: Sat, 30 Jun 2007 11:09:22 +0100
From: Christoph Hellwig <hch@infradead.org>
To: peter@chubb.wattle.id.au
Cc: Christoph Hellwig <hch@infradead.org>, Jared Hulbert <jaredeh@gmail.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: vm/fs meetup in september?
Message-ID: <20070630100922.GA23495@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	peter@chubb.wattle.id.au, Jared Hulbert <jaredeh@gmail.com>,
	Nick Piggin <npiggin@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-fsdevel@vger.kernel.org
References: <20070624042345.GB20033@wotan.suse.de> <6934efce0706251708h7ab8d7dal6682def601a82073@mail.gmail.com> <20070626060528.GA15134@infradead.org> <6934efce0706261007x5e402eebvc528d2d39abd03a3@mail.gmail.com> <20070630093243.GD22354@infradead.org> <87bqexiwu3.wl%peter@chubb.wattle.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bqexiwu3.wl%peter@chubb.wattle.id.au>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 06:02:44AM -0400, peter@chubb.wattle.id.au wrote:
> You need either a block translation layer, or a (swap) filesystem that
> understands flash peculiarities in order to make such a thing work.
> The standard Linux swap format will not work.

Yes, it basically needs an ftl.  

