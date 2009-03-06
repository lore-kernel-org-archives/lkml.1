Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbZCFNFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbZCFNFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZCFNEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:04:55 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:21959
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750937AbZCFNEy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:04:54 -0500
X-BigFish: VPS-27(zz1432R98dR1805M936fKzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KG35NT-01-IZQ-01
Date: Fri, 6 Mar 2009 14:04:43 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] various x86 kvm fixes
Message-ID: <20090306130443.GG8751@amd.com>
References: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com> <20090305215037.GA6532@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090305215037.GA6532@amt.cnet>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 06 Mar 2009 13:04:43.0305 (UTC) FILETIME=[1DED7190:01C99E5C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 06:50:37PM -0300, Marcelo Tosatti wrote:
> On Thu, Mar 05, 2009 at 01:12:27PM +0100, Joerg Roedel wrote:
> > Hi Avi, Marcelo,
> > 
> > this small series of patches collects some fixes I have collected during
> > the last days of KVM hacking. Please review and comment or apply if
> > appropriate :)
> 
> Applied 2, 3 and 6.

Thanks. Sorry for the two false positives. After so much mmu debugging
in the last days it seems I start to see ghost bugs :(

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

