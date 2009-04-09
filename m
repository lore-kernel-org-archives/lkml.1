Return-Path: <linux-kernel-owner+w=401wt.eu-S933862AbZDIM6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862AbZDIM6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 08:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758974AbZDIM6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 08:58:38 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:34203
	"EHLO WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751176AbZDIM6h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 08:58:37 -0400
X-BigFish: VPS8(zz154dM4015Mzz1202hzz3198u327alz32i6bh63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KHU40N-02-NAN-01
Date: Thu, 9 Apr 2009 14:56:59 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] x86: cacheinfo: cache_disable fixes/cleanup
Message-ID: <20090409125659.GD31527@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 Apr 2009 12:57:00.0071 (UTC) FILETIME=[ABDD0B70:01C9B912]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches primarily split up Mark's latest patch

  [PATCH][retry 6] Conform L3 Cache Index Disable to Linux Standards
  (see http://marc.info/?l=linux-kernel&m=123922420925908&w=2)

into smaller pieces. I prefer to revert the last two patches on
tip/x86/cpu to get a cleaner changelog for the following fixes.

Patches are against tip/x86/cpu as of today.

Please apply.


Thanks,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


