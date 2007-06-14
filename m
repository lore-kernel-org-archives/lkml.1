Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbXFNUGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbXFNUGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXFNUGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:06:41 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43942 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbXFNUGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:06:40 -0400
Date: Thu, 14 Jun 2007 22:07:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 01/14] Define functions for page cache handling
Message-ID: <20070614200743.GC2258@uranus.ravnborg.org>
References: <20070614193839.878721298@sgi.com> <20070614194052.663061482@sgi.com> <20070614195646.GB2258@uranus.ravnborg.org> <Pine.LNX.4.64.0706141257390.964@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706141257390.964@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 12:58:21PM -0700, Christoph Lameter wrote:
> On Thu, 14 Jun 2007, Sam Ravnborg wrote:
> 
> > We need access to PAGE_SIZE in vmlinux.lds.h.
> > What is your plan with that usage?
> 
> This is about PAGE_CACHE_xxx. No changes to PAGE__SIZE are planned.

Obviously - thanks for the quick response.

	Sam
