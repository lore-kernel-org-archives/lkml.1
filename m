Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbZJZT2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbZJZT2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbZJZT2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:28:19 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:37584 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbZJZT2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:28:18 -0400
X-SpamScore: 1
X-BigFish: VPS1(z34a4jz98dNzz1202hzzz32i6bh2ddj43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KS4ZE7-03-HZ2-02
X-M-MSG: 
Date: Mon, 26 Oct 2009 20:27:42 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mike Travis <travis@sgi.com>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Andreas Mohr <andi@lisas.de>,
       Hugh Dickins <hugh@veritas.com>, Hannes Eder <hannes@hanneseder.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] SGI x86_64 UV: Limit the number of microcode
 messages
Message-ID: <20091026192742.GA3985@aftab>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
 <20091023233756.941535000@alcatraz.americas.sgi.com>
 <b647ffbd0910241309u7b2f8c94t1f886ef31882539e@mail.gmail.com>
 <Pine.LNX.4.61.0910242207180.2439@ginsburg.homenet>
 <b647ffbd0910241545g4697a170peb00e541298d5a30@mail.gmail.com>
 <4AE5E9A0.1020009@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4AE5E9A0.1020009@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 26 Oct 2009 19:27:43.0190 (UTC) FILETIME=[63AB1F60:01CA5672]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 11:25:36AM -0700, Mike Travis wrote:
> I could add it for AMD but I can't test it, and I'm always reluctant to
> change things I can't verify.

Just send it to me, I'll test it for ya :)

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

