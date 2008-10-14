Return-Path: <linux-kernel-owner+w=401wt.eu-S1751681AbYJNN5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbYJNN5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 09:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbYJNN5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 09:57:25 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:43837 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbYJNN5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 09:57:24 -0400
X-BigFish: VPS-37(zz62a3L1432R98dR936eQ1805Mzzzzz32i6bh63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K8QERA-02-OPK-01
Date: Tue, 14 Oct 2008 15:56:45 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: oprofile-list <oprofile-list@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Oprofile kernel git tree
Message-ID: <20081014135645.GF23557@erda.amd.com>
References: <20081013202022.GE23557@erda.amd.com> <87r66kqlpt.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87r66kqlpt.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 14 Oct 2008 13:56:59.0550 (UTC) FILETIME=[BA3433E0:01C92E04]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.10.08 22:33:18, Andi Kleen wrote:
> Robert Richter <robert.richter@amd.com> writes:
> >
> > Feature branches (patches not yet ready for upstream, fast-forward only):
> >
> >  arch-perfmon
> 
> What do you mean with that? arch-perfmon is definitely ready for upstream.

This contains only the patch I wrote that changes the
initialization. All other patches are already in the upstream branch.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

