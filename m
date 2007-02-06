Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbXBFKGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbXBFKGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 05:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXBFKGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 05:06:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57233 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbXBFKGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 05:06:15 -0500
Date: Tue, 6 Feb 2007 10:06:07 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org,
       jkenisto@us.ibm.com, anil.s.keshavamurthy@intel.com,
       prasanna@in.ibm.com, ananth@in.ibm.com
Subject: Re: [RFC] [PATCH] To list all active probes in the system
Message-ID: <20070206100607.GA10296@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
	akpm@osdl.org, torvalds@osdl.org, jkenisto@us.ibm.com,
	anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com,
	ananth@in.ibm.com
References: <45C85097.1000106@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C85097.1000106@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 03:25:35PM +0530, Srinivasa Ds wrote:
> Hi folks
> 
>         I have developed a patch, that lists all active probes in the
> system. I have done this through /proc interface. Currently list is
> available under /proc/kprobes/list. Any suggestions for better place and
> name??

/debug/kprobes/list? :)

