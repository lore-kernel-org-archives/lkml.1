Return-Path: <linux-kernel-owner+w=401wt.eu-S1761199AbXK1OmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761199AbXK1OmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbXK1Ol7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:41:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34321 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbXK1Ol6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:41:58 -0500
Date: Wed, 28 Nov 2007 14:41:56 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071128144156.GA14106@infradead.org>
References: <200711281242.52941.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711281242.52941.tvrtko.ursulin@sophos.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 12:42:52PM +0000, Tvrtko A. Ursulin wrote:
> 
> Hi Linus, all,
> 
> During one recent LKML discussion 
> (http://marc.info/?l=linux-kernel&m=119267398722085&w=2) about LSM going 
> static  you called for LSM users to speak up.
> 
> We here at Sophos (the fourth largest endpoint security vendor in the world) 
> have such a module called Talpa which is a part of our main endpoint security 
> product for Linux  that protects from viruses and malware hosted on Linux, 
> including those targetting Windows or other connected devices,  
> (http://www.sophos.com/products/enterprise/endpoint/security-and-control/linux/index.html) 
> which is GPL code and has been in the field for almost three years now. It's 
> source code has been shipping with the product from the start.  We also have 
> a SourceForge project at http://sourceforge.net/projects/talpa/ to host it.

Thanks for showing a wonderful source code example of why lsm shouldn't
be exported :)
