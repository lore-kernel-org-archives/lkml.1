Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbYD3Itt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbYD3Itt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 04:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbYD3Itk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 04:49:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53422 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbYD3Itj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 04:49:39 -0400
Date: Wed, 30 Apr 2008 04:49:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: make MAINTAINERS email addresses easier to copy/paste
Message-ID: <20080430084938.GA31984@infradead.org>
References: <200804291459.56300.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804291459.56300.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 02:59:56PM -0600, Bjorn Helgaas wrote:
> The current MAINTAINERS file format makes it a nuisance to
> copy both the display name and the actual address.  So
> I propose that we fold together the current "P:" and "M:"
> lines using something similar to the filter below.

Why do you want to copy the real name?  It's entirely superflous for
mail routing.

