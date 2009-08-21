Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbZHUKf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbZHUKf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 06:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbZHUKfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 06:35:25 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:6793 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751829AbZHUKfY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 06:35:24 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432R98dN4015La594izz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KOQ2QK-01-6H3-02
X-M-MSG: 
Date: Fri, 21 Aug 2009 12:34:51 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: [PATCH 0/5 v4] x86: Adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090821103451.GR29515@alberich.amd.com>
References: <20090805154402.GA6520@alberich.amd.com> <20090808151731.GD28892@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090808151731.GD28892@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 21 Aug 2009 10:34:53.0594 (UTC) FILETIME=[050A67A0:01CA224B]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 08, 2009 at 05:17:31PM +0200, Ingo Molnar wrote:
> 
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > Note that scheduler adaptions are still under construction/test. 
> > Hope to send first version as RFC by end of this week.
> 
> Ok - i'll wait for those, and they really put all this info into 
> real use so bugs/inefficiencies can be noticed.

The scheduler adaptions were submitted yesterday.
(http://lkml.org/lkml/2009/8/7/210)
 
> You also indicated that you'll address the feedback from Brice 
> Goglin to make the semantics (and naming) more consistent across the 
> kernel.

That's done in the v5 patch set, see
http://lkml.org/lkml/2009/8/7/210


Please reconsider to apply the topology stuff to tip-tree.


Thanks,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


