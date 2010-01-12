Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645Ab0ALSVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0ALSVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 13:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157Ab0ALSVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 13:21:02 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:3626 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754101Ab0ALSVA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 13:21:00 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zz1432R98dNzz1202hzz5a6ciz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KW5C7O-01-KRD-02
X-M-MSG: 
Date: Tue, 12 Jan 2010 19:19:37 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Roel Kluin <roel.kluin@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, dougthompson@xmission.com
Subject: Re: [PATCH] amd64_edac: index not within bounds in
 amd64_get_scrub_rate()
Message-ID: <20100112181937.GG32599@aftab>
References: <4B4B82DD.4040209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4B4B82DD.4040209@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 12 Jan 2010 18:19:00.0871 (UTC) FILETIME=[B6CBA970:01CA93B3]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 08:58:21PM +0100, Roel Kluin wrote:
> Ensure index stays within bound in amd64_get_scrub_rate()
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied, thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

