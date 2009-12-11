Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbZLKSgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbZLKSgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 13:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758863AbZLKSgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 13:36:36 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:5947 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758502AbZLKSgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 13:36:35 -0500
X-SpamScore: -31
X-BigFish: VPS-31(zz1432R98dN936eM9371P103dKzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KUI3OT-02-HAA-02
X-M-MSG: 
Date: Fri, 11 Dec 2009 19:36:35 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Aristeu Rozanski <aris@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org,
       x86 <x86@kernel.org>
Subject: Re: [PATCH v2] x86, msr: add support for non-contiguous cpumasks
Message-ID: <20091211183635.GE31998@aftab>
References: <20091207122133.GA24877@aftab>
 <4B21A50E.5090801@zytor.com>
 <20091211171440.GD31998@aftab>
 <4B228902.7010609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4B228902.7010609@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 11 Dec 2009 18:36:31.0770 (UTC) FILETIME=[DBF61FA0:01CA7A90]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 10:01:38AM -0800, H. Peter Anvin wrote:
> On 12/11/2009 09:14 AM, Borislav Petkov wrote:
> > Ok, here's a second (and much leaner, removing a bunch of code) version.
> > Tested on K8 and F10h machines here.
> 
> Much better, thanks!

Ok, cool. Should I send it to Linus or would you like to do it?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

