Return-Path: <linux-kernel-owner+w=401wt.eu-S934597AbZHEO5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934597AbZHEO5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934583AbZHEO5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:57:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38208 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934566AbZHEO5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:57:14 -0400
Date: Wed, 5 Aug 2009 10:57:13 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Julia Lawall <julia@diku.dk>
Cc: Helge Deller <deller@gmx.de>, Kyle McMartin <kyle@mcmartin.ca>,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] arch/parisc: correct use of SHF_ALLOC
Message-ID: <20090805145713.GP28572@bombadil.infradead.org>
References: <Pine.LNX.4.64.0908042226231.3737@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908042226231.3737@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 10:27:07PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> SHF_ALLOC is suitable for testing against the sh_flags field, not the
> sh_type field.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 

Thanks Julia, applied.
