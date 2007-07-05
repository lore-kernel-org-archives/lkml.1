Return-Path: <linux-kernel-owner+w=401wt.eu-S1762502AbXGEUle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762502AbXGEUle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758368AbXGEUl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:41:27 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:46568 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872AbXGEUl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:41:26 -0400
Date: Thu, 5 Jul 2007 16:41:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070705204124.GA1341@Krystal>
References: <20070703164046.645090494@polymtl.ca> <20070703164516.377240547@polymtl.ca> <20070703181151.GB5800@martell.zuzino.mipt.ru> <20070703185748.GA4047@Krystal> <20070705132120.8edbc1f3.akpm@linux-foundation.org> <20070705132928.76783253.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070705132928.76783253.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:41:04 up 4 days, 15:24,  5 users,  load average: 4.81, 1.90, 1.20
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Thu, 5 Jul 2007 13:21:20 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Please prepare and maintain a short document which describes the
> > justification for making all these changes to the kernel.
> 
> oh, you did.  It's there in the add-kconfig-stuff patch.

Yes, if you feel it should be put in a different patch header, I'll move
it.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
