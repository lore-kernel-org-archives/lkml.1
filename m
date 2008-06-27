Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYF0JPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYF0JPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 05:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYF0JPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 05:15:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39496 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYF0JPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 05:15:42 -0400
Date: Fri, 27 Jun 2008 05:15:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Dave Chinner <david@fromorbit.com>,
       xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
Message-ID: <20080627091509.GA31148@infradead.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <1214512405.21035.110.camel@localhost.localdomain> <20080627022407.GB7703@parisc-linux.org> <1214537199.21035.179.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214537199.21035.179.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 08:26:39PM -0700, Daniel Walker wrote:
> Are you saying you want to keep semaphores? Cause I think that goes
> against the overall agenda that I've seen,

Which overall agenda? 

