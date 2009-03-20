Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbZCTHgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbZCTHgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 03:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbZCTHgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 03:36:42 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:46129 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbZCTHgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 03:36:42 -0400
Date: Fri, 20 Mar 2009 09:36:40 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Lava dual parallel PCI card IRQ problem
In-Reply-To: <Pine.SOC.4.64.0903191542500.26750@math.ut.ee>
Message-ID: <Pine.SOC.4.64.0903200930290.15666@math.ut.ee>
References: <20090318143921.22B5B13A4B0@koiott.tartu-labor>
 <Pine.LNX.4.64.0903191500520.4721@ondatra.tartu-labor>
 <20090319131002.4040b4dd@lxorguk.ukuu.org.uk> <Pine.SOC.4.64.0903191525001.26750@math.ut.ee>
 <Pine.SOC.4.64.0903191542500.26750@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Printer prints without the patch.
> 
> The whole system hangs hard when trying to print with the patch applied. 
> 100% repeatable, and with loglevel 9, nothing appears on the console.

Recompiled the kernels with most debug options turned on under kernel 
hacking menu, still no messages.

-- 
Meelis Roos (mroos@linux.ee)
