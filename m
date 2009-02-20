Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbZBTXIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbZBTXIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbZBTXIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:08:09 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:62992 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbZBTXII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:08:08 -0500
X-BigFish: VPS-4(zz4015Mzzzzz32i6bh65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KFE08T-01-JTM-01
Date: Sat, 21 Feb 2009 00:07:29 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Mark Hounschell <markh@compro.net>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/3] x86: dish of assorted hpet patches
Message-ID: <20090220230729.GK4834@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Feb 2009 23:07:50.0553 (UTC) FILETIME=[0D6CC890:01C993B0]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- to print HPET registers during setup,
- to fix a real issue with HZ_1000 kernels on an SB400 system
 (and to potentially fix a similar issue with SB600).

Tested on ICH7 and on AMD SB400, AMD SB600.


Please apply.

Thanks,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


