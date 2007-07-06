Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbXGFXjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbXGFXjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 19:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXGFXjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 19:39:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbXGFXjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 19:39:43 -0400
Date: Fri, 6 Jul 2007 19:38:27 -0400
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070706233827.GC13125@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@stusta.de>, Chuck Ebbert <cebbert@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
References: <20070703164046.645090494@polymtl.ca> <20070703164516.377240547@polymtl.ca> <20070703181151.GB5800@martell.zuzino.mipt.ru> <20070703185748.GA4047@Krystal> <20070705132120.8edbc1f3.akpm@linux-foundation.org> <p73vecx21um.fsf@bingen.suse.de> <468EBEB2.4070605@redhat.com> <20070706232843.GT3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070706232843.GT3492@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 01:28:43AM +0200, Adrian Bunk wrote:

 > Only if you want to squeeze the last bit of performance out of
 > _debugging_ functionality.
 > 
 > You avoid all the pain if you simply don't use debugging functionality 
 > on production systems.

I think you're mixing up profiling and debugging.   The former is
extremely valuable under production systems.

	Dave

-- 
http://www.codemonkey.org.uk
