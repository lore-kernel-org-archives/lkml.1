Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983Ab0ADNWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab0ADNWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 08:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260Ab0ADNWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 08:22:31 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:36756
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751212Ab0ADNWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 08:22:30 -0500
X-SpamScore: -16
X-BigFish: VPS-16(zz1432R98dNzz1202hzzz32i362I6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KVQ51T-02-537-02
X-M-MSG: 
Date: Mon, 4 Jan 2010 14:20:19 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, stable@kernel.org, tglx@linutronix.de,
       sruffell@digium.com, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] dma-debug: Fix bug causing build warning
Message-ID: <20100104132018.GH14679@amd.com>
References: <20091231125624.GA14666@liondog.tnic>
 <tip-a8fe9ea200ea21421ea750423d1d4d4f7ce037cf@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <tip-a8fe9ea200ea21421ea750423d1d4d4f7ce037cf@git.kernel.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Jan 2010 13:20:19.0330 (UTC) FILETIME=[A96B8620:01CA8D40]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 02:31:08PM +0000, tip-bot for Ingo Molnar wrote:
> Stephen Rothwell reported the following build warning:
> 
>  lib/dma-debug.c: In function 'dma_debug_device_change':
>  lib/dma-debug.c:680: warning: 'return' with no value, in function returning non-void
> 
> Introduced by commit f797d9881b62c2ddb1d2e7bd80d87141949c84aa
> ("dma-debug: Do not add notifier when dma debugging is disabled").

Oops, sorry. Stupid mistake :-(

	Joerg


