Return-Path: <linux-kernel-owner+w=401wt.eu-S1751658AbZG3MHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbZG3MHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZG3MHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:07:51 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:23990
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751162AbZG3MHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:07:51 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz62a3L4015Lzz1202hzzz32i6bh203h43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KNLGCT-03-T4D-01
Date: Thu, 30 Jul 2009 14:07:38 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: OProfile for linux-next
Message-ID: <20090730120738.GA24694@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 30 Jul 2009 12:07:39.0606 (UTC) FILETIME=[558DEF60:01CA110E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

please add following tree to linux-next:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-next

This is the oprofile master branch containing all changes for the next
merge window.

The general way of sending oprofile to linux-next is via tip. So, this
will be a temporary solution until Ingo will be back.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

