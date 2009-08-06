Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbZHFG1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbZHFG1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 02:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZHFG1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 02:27:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33848 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZHFG1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 02:27:07 -0400
Message-ID: <4A7A77B6.9050306@zytor.com>
Date: Wed, 05 Aug 2009 23:27:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH -v2 4/5] x86: Move kernel_fpu_using to irq_is_fpu_using
 in asm/i387.h
References: <1249285531-22422-1-git-send-email-ying.huang@intel.com> <1249285531-22422-2-git-send-email-ying.huang@intel.com> <1249285531-22422-3-git-send-email-ying.huang@intel.com> <1249285531-22422-4-git-send-email-ying.huang@intel.com> <20090806053719.GD23557@gondor.apana.org.au>
In-Reply-To: <20090806053719.GD23557@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> 
> Peter, do you want to apply this patch in your tree or would
> you prefer for it to go through my tree along with the rest of
> the series?
> 

I'll take it tomorrow... want to double-check that we don't have any 
real issues w.r.t. corruption there.

	-hpa
