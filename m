Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbZH0O4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbZH0O4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZH0O4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:56:40 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:60444 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbZH0O4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:56:39 -0400
Date: Thu, 27 Aug 2009 15:56:57 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Daney <ddaney@caviumnetworks.com>, mpm@selenic.com,
       linux-mips@linux-mips.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] hw_random: Add hardware RNG for Octeon SOCs.
Message-ID: <20090827145657.GG29984@linux-mips.org>
References: <4A8DBB17.5020301@caviumnetworks.com> <1250802623-6526-2-git-send-email-ddaney@caviumnetworks.com> <20090824074745.GB32067@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824074745.GB32067@gondor.apana.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 05:47:45PM +1000, Herbert Xu wrote:

> On Thu, Aug 20, 2009 at 02:10:23PM -0700, David Daney wrote:
> > Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Queued for 2.6.32 after fixing the space followed by tab mess in Kconfig.

Thanks,

  Ralf
