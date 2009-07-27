Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbZG0RCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbZG0RCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 13:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZG0RCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 13:02:20 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:8898 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbZG0RCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 13:02:19 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz98dNzz1202hzzz32i6bh203h6di62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 8,
X-WSS-ID: 0KNG9ZI-02-3QW-02
X-M-MSG: 
Date: Mon, 27 Jul 2009 19:01:48 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: wan wei <onewayforever@gmail.com>
CC: dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd64_edac: fix insmod fail while ecc is enabled
Message-ID: <20090727170148.GG28229@aftab>
References: <86bb1aef0907270947o6219f950xf13a077b30486d41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <86bb1aef0907270947o6219f950xf13a077b30486d41@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Jul 2009 17:01:46.0444 (UTC) FILETIME=[ECA678C0:01CA0EDB]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 12:47:33AM +0800, wan wei wrote:
> Signed-off-by: Wan Wei<wanwei@mail.dawning.com.cn>

Thanks for that but I have a patch addressing the issue and wanted
to test it a bit in linux-next before sending it to Linus. I'd much
appreciate it if you gave it a try:

http://git.kernel.org/?p=linux/kernel/git/bp/bp.git;a=commit;h=076119c66b80ebc7da2d76c8d414fa9fa0ed577a

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

