Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYIXQem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYIXQem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYIXQef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:34:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45246 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbYIXQee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:34:34 -0400
Date: Wed, 24 Sep 2008 12:34:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Pawe? Sikora <pluto@agmk.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [kernel-abi] symbol versioning vs. out-of-tree modules.
Message-ID: <20080924163431.GA25014@infradead.org>
References: <Y165ES5i.1222268879.9618400.pluto@agmk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y165ES5i.1222268879.9618400.pluto@agmk.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 05:07:59PM +0200, Pawe? Sikora wrote:
> Hi All,
> 
> with out-of-tree kernel modules we (users and linux distributions)

"we" aka the idiots that use out of tree modules on production systems.
Just stop doing that, and your problem is solved.

