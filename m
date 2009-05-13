Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbZEMGhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbZEMGhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 02:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbZEMGhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 02:37:32 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:55607 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756066AbZEMGha convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 02:37:30 -0400
X-BigFish: VPS3(z34a4jzzz1202hzzz32i6bh)
X-FB-SS: 13,
X-WSS-ID: 0KJKL2A-02-RZJ-01
Date: Wed, 13 May 2009 08:36:49 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 5/10 -tip] x86: check_powernow() for K8 and later user
	of Advanced Power Management features
Message-ID: <20090513063649.GF9991@alberich.amd.com>
References: <1242142530.2547.11.camel@ht.satnam> <1242142623.2547.13.camel@ht.satnam> <1242142692.2547.15.camel@ht.satnam> <1242142753.2547.16.camel@ht.satnam> <1242142807.2547.18.camel@ht.satnam> <1242142849.2547.19.camel@ht.satnam> <20090512174848.GA3313@elte.hu> <1242153926.2492.49.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1242153926.2492.49.camel@ht.satnam>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 May 2009 06:37:18.0241 (UTC) FILETIME=[42E12910:01C9D395]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You should involve the maintainer of powernow-k8 when submitting patches for this driver.
It's Mark Langsdorf (mark.langsdorf@amd.com).

Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


