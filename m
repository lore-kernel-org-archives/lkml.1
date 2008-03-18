Return-Path: <linux-kernel-owner+w=401wt.eu-S943886AbYCTADL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943886AbYCTADL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S941635AbYCSWvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:51:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:60726 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S941627AbYCSWvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:51:46 -0400
Message-ID: <47E00011.8060508@nerdbynature.de>
Date: Tue, 18 Mar 2008 18:46:57 +0100
From: Christian Kujau <lists@nerdbynature.de>
User-Agent: Thunderbird 3.0a1pre (Macintosh/2008030403)
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>,
       David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, dm-devel@redhat.com, dm-crypt@saout.de,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Ritesh Raj Sarraf <rrs@researchut.com>
Subject: Re: [dm-crypt] INFO: task mount:11202 blocked for more than 120 seconds
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <alpine.DEB.1.00.0803161406040.6213@sheep.housecafe.de> <20080317173609.GD29322@agk.fab.redhat.com> <200803171936.22260.chunkeey@web.de>
In-Reply-To: <200803171936.22260.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19eBReylrrTOexT8zEQVC1uFiJzZfwurNC2lm1
 2htiydzYssRq6wCSV5bWl6gj6tBQegBrgYvxsUQl1Oi8+TYgoI
 ETZs60Tv6nOQiut2dYDZME1vV8X938KfPD2Ssf21Bg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chr wrote:
> Well, the dm-crypt regressions seems to be gone. :)
> Thanks for your work&  time!

Unfortunately I'm unable to test atm as I currently don't have access to 
the machine where the hangs occured. So, if Chr says "it's fixed" I 
believe it is and I don't wanna be a show stopper...IOW: feel free to 
close the bug.

Thanks to all involved,
Christian.




