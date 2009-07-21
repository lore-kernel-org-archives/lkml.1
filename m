Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbZGUKvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbZGUKvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZGUKvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:51:52 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:3397 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850AbZGUKvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:51:51 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz98dNzz1202hzzz32i6bh6di61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KN4OU0-02-752-01
Date: Tue, 21 Jul 2009 12:51:05 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Doug Thompson <norsk5@yahoo.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, aris@redhat.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding II
Message-ID: <20090721105105.GE32338@aftab>
References: <20090720180446.GB16072@basil.fritz.box>
 <935428.51568.qm@web50110.mail.re2.yahoo.com>
 <20090720194419.GD16072@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090720194419.GD16072@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Jul 2009 10:51:05.0846 (UTC) FILETIME=[25BE0960:01CA09F1]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 09:44:19PM +0200, Andi Kleen wrote:

> As far as I can see this whole thing barely works even on AMD
> due to the other problems.

Care to let us in on those so that we get a chance to fix them?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

