Return-Path: <linux-kernel-owner+w=401wt.eu-S935865AbZLPWqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935865AbZLPWqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935408AbZLPWqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:46:13 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:55112 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934286AbZLPWqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:46:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsEANvvKEuuWOl3/2dsb2JhbACBS5pguUuEKwSBYw
Date: Wed, 16 Dec 2009 17:41:00 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: leonid.moiseichuk@nokia.com, Viktor.Rosendahl@nokia.com, tony@atomide.com,
       eero.tamminen@nokia.com
Cc: Felipe Balbi <felipe.balbi@nokia.com>,
       "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RELEASE] LTTV 0.12.25
Message-ID: <20091216224100.GA12533@Krystal>
References: <20091204160633.GA29864@Krystal> <20091213194210.GA3149@nokia.com> <20091216213546.GA5609@Krystal> <20091216222916.GA11101@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091216222916.GA11101@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:39:03 up  6:57,  4 users,  load average: 0.16, 0.11, 0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTV 0.12.25 can be useful to view traces taken from an ARM omap3 board.
This release works around a problem with irq tables experienced with IRQ
IDs > 256, which I have seen on the ARM omap3.

Available at http://lttng.org

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
