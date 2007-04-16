Return-Path: <linux-kernel-owner+w=401wt.eu-S1030490AbXDPMBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030490AbXDPMBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 08:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030503AbXDPMBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 08:01:44 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:55515 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030490AbXDPMBn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 08:01:43 -0400
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Mon, 16 Apr 2007 15:02:26 +0300
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070413202100.GA9957@elte.hu> <200704160149.42914.ismail@pardus.org.tr> <20070416115854.GA27566@elte.hu>
In-Reply-To: <20070416115854.GA27566@elte.hu>
X-Face: 9Va_@~iRiB"*X1O@K#(=?utf-8?q?thBxy=236XXkD87I=3DG=7E=23=26tFA=26=24mM+4oHIQZGdgCx9=23IZ=7ByL-?=
 =?utf-8?q?rk8CY=0A=09u=3B=7DX=7D?=,+R%vB]|/kKH:-<%Mym?njPCL%'gcIX.J$I}9+{Q|vvl0&c+>WFNbuN,>)
 =?utf-8?q?Of=3AUJq0=0A=09=7DL9+?="}tE:hB<t]y=^%m/R6z.OA8}$@VZ6N?m?h4^,GBNW&xS]9'I?;1OEohho"yF>
 =?utf-8?q?s36=7EN=0A=09=5CE0=60?=@O~`!C>JQkL|pqY{]A7Ow0PD$;BJ9^%!$[hV?(lrTA\rJk\rxnz>oW&W,
 =?utf-8?q?=3DE3obyZfC=0A=09=5EC=7BbqWCY?=
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704161502.26942.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2007 14:58:54 Ingo Molnar wrote:
> * Ismail Dönmez <ismail@pardus.org.tr> wrote:
> > Tested this on top of Linus' GIT tree but the system gets very
> > unresponsive during high disk i/o using ext3 as filesystem but even
> > writing a 300mb file to a usb disk (iPod actually) has the same
> > affect.
>
> hm. Is this an SMP system+kernel by any chance?

Nope the kernel and the system is UP.

Regards,
ismail

