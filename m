Return-Path: <linux-kernel-owner+w=401wt.eu-S1161537AbXECIIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161537AbXECIIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161791AbXECIIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:08:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59593 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161537AbXECIIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:08:18 -0400
Date: Thu, 3 May 2007 09:08:12 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070503080812.GB23000@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	rusty@rustcorp.com.au, wfg@ustc.edu
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <p733b2gzqkg.fsf@bingen.suse.de> <20070501220803.GA27698@Krystal> <20070502104413.GC4392@one.firstfloor.org> <20070502094707.4197ab7a.akpm@linux-foundation.org> <20070502172934.GA17782@infradead.org> <20070502203627.GA18733@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502203627.GA18733@Krystal>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 04:36:27PM -0400, Mathieu Desnoyers wrote:
> The idea is the following : either we integrate the infrastructure for
> instrumentation / data serialization / buffer management / extraction of
> data to user space in multiple different steps, which makes code review
> easier for you guys,

the staging area for that is -mm

