Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbZCLT06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbZCLT06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 15:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZCLT0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 15:26:46 -0400
Received: from www.tglx.de ([62.245.132.106]:37457 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbZCLT0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 15:26:46 -0400
Date: Thu, 12 Mar 2009 20:25:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Tate, Patrick O" <patrick.o.tate2@pss.boeing.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       "Lykken, Allan D" <allan.d.lykken@boeing.com>
Subject: Re: Build error with realtime patch on ppc platform
In-Reply-To: <1A35CC2FF2016840923376BD5C2B3DAC0B6791EF@XCH-NW-6V1.nw.nos.boeing.com>
Message-ID: <alpine.LFD.2.00.0903122022080.29264@localhost.localdomain>
References: <1A35CC2FF2016840923376BD5C2B3DAC0B6791EF@XCH-NW-6V1.nw.nos.boeing.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pat,

On Thu, 12 Mar 2009, Tate, Patrick O wrote:
> Hi Ingo
> 
> My name is Pat Tate and I was trying to build a kernel with the realtime
> patch on a powerpc. We are using the YDL 4.1 distribution.
> I pulled down the linux 2.6.29-rc6 with the realtime
> patch-2.6.29-rc6-rt3.

I have not yet found the time to bring powerpc -rt support back to
life. We dropped it due to lack of time when we ported it forward from
2.6.26 to 2.6.29. It's work in progress. I have some bits and pieces
done already and will integrate them into the next release. That
should be at least a halfways reasonable starting point.

Thanks,

	tglx

