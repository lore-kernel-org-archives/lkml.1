Return-Path: <linux-kernel-owner+w=401wt.eu-S1762671AbXJEAB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762671AbXJEAB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 20:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759438AbXJEABv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 20:01:51 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:40157 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbXJEABt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 20:01:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bvxwhx2QD+OXAvVpIKRu2Xxm14b0e8QsTevwkWlmaviw0qtiioRsC26kuDp3yH7aRWiSpJdCmRBK91HFQw9DXH6rAmI5JxOebKvwDtZ6EcF0SVrjQs38EH5HNny5VKI0KPsLdf1pDdnSV2x5G0eFSEQoPyvCNuscEiW6q3fI42A=
Message-ID: <29495f1d0710041701g4ed73441ie583058c78f95857@mail.gmail.com>
Date: Thu, 4 Oct 2007 17:01:47 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Tony Breeds" <tony@bakeyournoodle.com>
Subject: Re: 2.6.23-rc7-mm1 -- powerpc rtas panic
Cc: "Michael Ellerman" <michael@ellerman.id.au>,
       "Linas Vepstas" <linas@austin.ibm.com>, linuxppc-dev@ozlabs.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071003011909.GG9814@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
	 <20070924123531.GC30855@shadowen.org>
	 <20071002232819.GN4338@austin.ibm.com>
	 <20071003002646.GD9814@bakeyournoodle.com>
	 <1191371416.8073.1.camel@concordia>
	 <20071003011909.GG9814@bakeyournoodle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/07, Tony Breeds <tony@bakeyournoodle.com> wrote:
> On Wed, Oct 03, 2007 at 10:30:16AM +1000, Michael Ellerman wrote:
>
> > I realise it'll make the patch bigger, but this doesn't seem like a
> > particularly good name for the variable anymore.
>
> Sure, what about?
>
> Clarify when RTAS logging is enabled.
>
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

For what it's worth, on a different ppc64 box, this resolves a similar
panic for me.

Tested-by: Nishanth Aravamudan <nacc@us.ibm.com>

Thanks,
Nish
