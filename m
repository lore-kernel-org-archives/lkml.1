Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbZKEMyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbZKEMyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 07:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbZKEMya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 07:54:30 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:45789 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZKEMy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 07:54:29 -0500
X-SpamScore: -1
X-BigFish: VPS-1(z34a4jz98dNzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KSMZUN-04-2H0-02
X-M-MSG: 
Date: Thu, 5 Nov 2009 13:54:38 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] cpumask: use struct cpumask rather than the deprecated
 cpumask_t
Message-ID: <20091105125438.GB17984@aftab>
References: <200911052245.41803.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <200911052245.41803.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 05 Nov 2009 12:54:22.0468 (UTC) FILETIME=[18AC3C40:01CA5E17]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 10:45:41PM +1030, Rusty Russell wrote:
> This makes the declarations match the definitions, which already use
> 'struct cpumask'.

Oops, I missed those, thanks.

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

