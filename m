Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbZHNMAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbZHNMAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbZHNMAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:00:49 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:50360
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752878AbZHNMAs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:00:48 -0400
X-SpamScore: -7
X-BigFish: VPS-7(zz98dN148cMa4a4kzz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KOD810-02-K6C-02
X-M-MSG: 
Date: Fri, 14 Aug 2009 14:00:31 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Kevin Winchester <kjwinchester@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: Mikael Pettersson <mikpe@it.uu.se>,
       Borislav Petkov <petkovbb@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH v3] x86: clear incorrectly forced X86_FEATURE_LAHF_LM
 flag
Message-ID: <20090814120031.GA7197@aftab>
References: <4A80A5AD.2000209@gmail.com>
 <19073.33348.459260.456740@pilspetsen.it.uu.se>
 <20090811155106.GB16173@aftab>
 <d1af83620908110855x75b1e5aeq6d814ca90c49ec22@mail.gmail.com>
 <20090811160116.GD16173@aftab>
 <4A8209B6.8050306@gmail.com>
 <20090812114038.GD15396@aftab>
 <4A8349F6.9080107@gmail.com>
 <20090813122337.GB7029@aftab>
 <4A84A0BA.7040802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A84A0BA.7040802@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 Aug 2009 12:00:35.0453 (UTC) FILETIME=[D4EF92D0:01CA1CD6]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Thu, Aug 13, 2009 at 08:24:42PM -0300, Kevin Winchester wrote:
> Yes, those patches seem to fix everything:

Thanks for testing and helping along the way.

@Ingo: I'm sending the final patches as a reply to that mail.
Considering that the issue can be observed only on revA-C K8s _with_
broken BIOSes I can't say that it is that urgent. In that case we can
conveniently wait for the merge window for a wider exposure and testing;
I'm happy with whatever you decide.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

