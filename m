Return-Path: <linux-kernel-owner+w=401wt.eu-S1759729AbZLOUqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729AbZLOUqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbZLOUqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:46:21 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:6078 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752424AbZLOUqU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:46:20 -0500
X-SpamScore: -5
X-BigFish: VPS-5(zz98dNzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KUPOCW-01-CRE-02
X-M-MSG: 
Date: Tue, 15 Dec 2009 21:46:16 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Andreas Herrmann <herrmann.der.user@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] x86, amd: Get multi-node CPU info from NodeId
 MSR instead of PCI config space
Message-ID: <20091215204616.GA6611@aftab>
References: <mkk2iqhh6vhhmxaxruuvafvb.1260907236343@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <mkk2iqhh6vhhmxaxruuvafvb.1260907236343@email.android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 15 Dec 2009 20:46:05.0696 (UTC) FILETIME=[9F3C1800:01CA7DC7]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 12:00:36PM -0800, H. Peter Anvin wrote:
> That's nice.  It should be in the code, not in the commit message.

I'm pretty sure it'll land there tomorrow :).

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

