Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbZHRKuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbZHRKuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758076AbZHRKuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:50:11 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:56051 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754037AbZHRKuJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:50:09 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz4015L1b0bMzz1202hzzz32i6bh203h65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KOKJEX-01-8RD-02
X-M-MSG: 
Date: Tue, 18 Aug 2009 12:49:44 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 0/12] cleanup __build_sched_domains()
Message-ID: <20090818104944.GA29515@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Aug 2009 10:49:45.0572 (UTC) FILETIME=[99763240:01CA1FF1]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following patches try to make __build_sched_domains() less ugly
and more readable. They shouldn't be harmful. Thus I think
they can be applied for .32.

Patches are against tip/master as of today.

FYI, I need those patches as a base for introducing a new domain level
for multi-node CPUs for which I intend to sent patches as RFC asap.


Thanks,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


