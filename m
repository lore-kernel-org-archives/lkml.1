Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab0CJNKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:10:33 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:24979
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754837Ab0CJNKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:10:31 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zz1432Rzz1202hzzz32i6bh2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KZ2HWS-02-7N5-02
X-M-MSG: 
Date: Wed, 10 Mar 2010 14:10:30 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: fetch of edac-amd tree failed
Message-ID: <20100310131030.GB10679@aftab>
References: <20100310095013.2766db19.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100310095013.2766db19.sfr@canb.auug.org.au>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Mar 2010 13:10:03.0403 (UTC) FILETIME=[FF2645B0:01CAC052]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, Mar 10, 2010 at 09:50:13AM +1100

> Hi Borislav,
> 
> The linux-next fetch of the edac-amd tree has been failing like this for
> a few days:
> 
> fatal: Couldn't find remote ref refs/heads/for-next
> 
> I am still using the version from next-20100212 (which has been merged
> into Linus' tree).

Hi Stephen,

sorry about that. It should be fixed now, thanks.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center

