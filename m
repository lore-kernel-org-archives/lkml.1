Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbXKRRPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbXKRRPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 12:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXKRRPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 12:15:17 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:38384 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751177AbXKRRPQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 12:15:16 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAC8CQEdMROHU/2dsb2JhbACBWI8E
Date: Sun, 18 Nov 2007 12:15:13 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Borislav Petkov <bbpetkov@yahoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [rfc-patch 0/9] Immediate Values for 2.6.24-rc2-git5
Message-ID: <20071118171512.GB32074@Krystal>
References: <20071116200238.740495156@polymtl.ca> <20071117125007.GA4450@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20071117125007.GA4450@gollum.tnic>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:13:26 up 14 days, 22:18,  2 users,  load average: 0.63, 0.68,
	0.52
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Borislav Petkov (bbpetkov@yahoo.de) wrote:
> On Fri, Nov 16, 2007 at 03:02:38PM -0500, Mathieu Desnoyers wrote:
> Hi, 
> just a conventions proposal: have you thought of shortening all those
> "immediate_foo" prefixes to 'imm_foo', for example? This'll make the 
> code much more readable, i think.
> 

Well, if there are enough supporters of this idea, I'd be happy to
change "immediate_" for "imm_", since it's indeed shorter, easier to
type, and looks better in the code.

Anyone else agrees/disagrees ?

Mathieu

> - 
> Regards/Gruß,
>     Boris.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
