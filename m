Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbZLCKCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbZLCKCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 05:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZLCKCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 05:02:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51929 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZLCKCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 05:02:19 -0500
Subject: Re: [patch]  f83f9ac causes tasks running at MAX_PRIO
From: Peter Zijlstra <peterz@infradead.org>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4B17138D.3040003@bigpond.net.au>
References: <1259501027.6268.9.camel@marge.simson.net>
	 <1259754383.4003.610.camel@laptop>
	 <1259758150.6167.8.camel@marge.simson.net>
	 <4B17138D.3040003@bigpond.net.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Dec 2009 11:02:16 +0100
Message-ID: <1259834536.3977.165.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 11:25 +1000, Peter Williams wrote:

> Recent patches that I've submitted were intended as a start to removing 
> some of this cruft and I had intended to send more patches after they 
> were accepted.  I figured that it was better to do it as a number of 
> small changes rather than one big one.  Should I continue?

Please, feel free to clean that up.



