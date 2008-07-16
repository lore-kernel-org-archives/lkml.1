Return-Path: <linux-kernel-owner+w=401wt.eu-S1759160AbYGPPjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbYGPPjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbYGPPjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:39:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:5855 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbYGPPjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:39:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w8qfvq+/J9jvAOmzvr7VUt993KQlapT/GhJmM5ahspbxdtlze2PgGK5hDxZVpRGqWy
         4RdfistyMC3vYGlR9yKViJEs3X+8nP4Ke//9CM6sm1UuGP5pW+CgdJnw+cY1rVJoyR+s
         AgCkkTgweyu+OspYgbcT+/oEPHE5aGMjxPrDg=
Date: Wed, 16 Jul 2008 19:36:28 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: /proc/*/pagemap oopses
Message-ID: <20080716153628.GA5795@martell.zuzino.mipt.ru>
References: <20080716152025.GA23096@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716152025.GA23096@alice>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 05:20:25PM +0200, Eric Sesterhenn wrote:
> with current -git a "cat /proc/4260/pagemap"
> gives me the following oops:

reproduced

