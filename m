Return-Path: <linux-kernel-owner+w=401wt.eu-S1761440AbYGOVuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761440AbYGOVuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbYGOVub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:50:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57848 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbYGOVub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:50:31 -0400
Message-ID: <487D1AC0.5040602@zytor.com>
Date: Tue, 15 Jul 2008 17:46:40 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [git pull] core/percpu for v2.6.27
References: <20080714143413.GA19134@elte.hu> <alpine.LFD.1.10.0807141525000.2944@woody.linux-foundation.org> <487CC671.3000501@goop.org> <20080715210002.GA7072@elte.hu> <487D15FC.1060300@sgi.com>
In-Reply-To: <487D15FC.1060300@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> 
> 	4.2.3 is fine; he was using 4.2.0 before, and as far as I know,
>         4.2.0 and 4.2.1 are known broken for the kernel.
> 

I might have been misremembering about 4.2.[01]; Adrian Bunk reminds me 
that 4.*1*.[01] are definitely broken, and I can't simply remember the 
purported problem with 4.2, so it *may* be a case of off-by-one mental 
error.

	-hpa

