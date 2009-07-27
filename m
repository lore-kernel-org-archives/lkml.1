Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbZG0REY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbZG0REY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 13:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZG0REX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 13:04:23 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:16309
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752805AbZG0REX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 13:04:23 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz1432R98dNzz1202hzzz32i6bh203h6di43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KNGA2W-04-NRD-01
Date: Mon, 27 Jul 2009 19:04:14 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: wan wei <onewayforever@gmail.com>
CC: dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd64_edac: fix insmod fail while ecc is enabled
Message-ID: <20090727170414.GH28229@aftab>
References: <86bb1aef0907270947o6219f950xf13a077b30486d41@mail.gmail.com>
 <20090727170148.GG28229@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090727170148.GG28229@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Jul 2009 17:04:11.0580 (UTC) FILETIME=[432877C0:01CA0EDC]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 07:01:48PM +0200, Borislav Petkov wrote:
> On Tue, Jul 28, 2009 at 12:47:33AM +0800, wan wei wrote:
> > Signed-off-by: Wan Wei<wanwei@mail.dawning.com.cn>
> 
> Thanks for that but I have a patch addressing the issue and wanted
> to test it a bit in linux-next before sending it to Linus. I'd much
> appreciate it if you gave it a try:

Sorry, I meant

http://git.kernel.org/?p=linux/kernel/git/bp/bp.git;a=commit;h=4ad73bc713339d6c0be7abd9f49f46323ce614b6

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

