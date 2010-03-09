Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab0CIRcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:32:14 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55583 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0CIRcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:32:12 -0500
Date: Tue, 9 Mar 2010 18:32:34 +0100
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH] x86: Add optimized popcnt variants
Message-ID: <20100309173234.GE2371@aftab>
References: <20100223190614.GB2401@aftab>
 <4B875BBD.4060104@zytor.com>
 <20100226074714.GA15310@aftab>
 <4B88097E.7010608@zytor.com>
 <20100227082807.GA21706@aftab>
 <4B8979DA.9000201@zytor.com>
 <20100309153628.GA2371@aftab>
 <1268149840.5037.3.camel@laptop>
 <20100309162352.GB2371@aftab>
 <1268152369.5037.10.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268152369.5037.10.camel@laptop>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, Mar 09, 2010 at 05:32:49PM +0100

> I thought the patch did that, see this hunk (straight from
> http://lkml.org/lkml/2010/2/4/119 ):

Bollocks, I seem to have lost that hunk while applying the patch by
foot, sorry for the noise.

By the way, I can't seem to find your patch in Andrew's tree, is it
still going through his tree?

-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center
