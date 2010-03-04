Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab0CDVtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:49:22 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:9303 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751166Ab0CDVtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:49:20 -0500
X-SpamScore: -16
X-BigFish: VPS-16(zz154dM1432R10d1I14e1Izz1202hzzz32i6bh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KYS1XZ-01-5PK-02
X-M-MSG: 
Date: Thu, 4 Mar 2010 22:49:21 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mark Langsdorf <mark.langsdorf@amd.com>, <linux-kernel@vger.kernel.org>,
       <cpufreq@vger.kernel.org>, <bhavna.sarathy@amd.com>,
       <joachim.deguara@amd.com>
Subject: Re: [PATCH 3/3] cpufreq: add sysfs knob for toggling core
 performance boost
Message-ID: <20100304214921.GB29002@aftab>
References: <201003031459.27757.mark.langsdorf@amd.com>
 <20100304132743.e2b731da.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100304132743.e2b731da.akpm@linux-foundation.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Mar 2010 21:49:05.0755 (UTC) FILETIME=[82F592B0:01CABBE4]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, Mar 04, 2010 at 01:27:43PM -0800

> The lack of any changelog in a patch is usually a good sign that the
> patch needs a changelog :(

See my earlier mail.

[..]

> Well I've read the code and I've read the code comments and I've read
> the changelogs and I still have no clue what this thing does. 
> Apparently it allows me to toggle something called "APERF/MPERF".  I
> guess if I were patient enough, teh goog might tell me what that is,
> and why I might want it.  But this is all terribly inefficient.
> 
> I think you'd find that your feature is more useful and will be used by
> more people if you tell them (and us) what it does.

Basically, this is a knob for toggling of a core boosting feature
we have in Fam10h, rev.E CPUs. I'll have a proper changelog with a
hopefully understandable explanation soon :).

Thanks.

-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center

