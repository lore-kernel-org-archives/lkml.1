Return-Path: <linux-kernel-owner+w=401wt.eu-S935657AbZDBJph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935657AbZDBJph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935376AbZDBJpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:45:05 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:45987 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758014AbZDBJpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:45:03 -0400
Date: Thu, 2 Apr 2009 17:44:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: ghaskins@novell.com, anthony@codemonkey.ws, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090402094447.GA30639@gondor.apana.org.au>
References: <20090402085253.GA29932@gondor.apana.org.au> <49D47F11.6070400@redhat.com> <20090402091639.GA30126@gondor.apana.org.au> <49D484F5.2000400@redhat.com> <20090402092936.GA30333@gondor.apana.org.au> <49D487A6.407@redhat.com> <20090402094147.GA30586@gondor.apana.org.au> <49D488DA.8060005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D488DA.8060005@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 12:43:54PM +0300, Avi Kivity wrote:
>
> So we're back to "the problem is with the kernel->user interface, not  
> userspace being cursed into slowness".

Well until you have a patch + numbers that's only an allegation :)
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
