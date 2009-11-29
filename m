Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbZK2Uqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbZK2Uqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 15:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZK2Uqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 15:46:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:34105 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbZK2Uqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 15:46:32 -0500
Date: Sun, 29 Nov 2009 12:47:31 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Problem? intel_iommu=off; perf top shows acpi_os_read_port as
 extremely busy
Message-ID: <20091129124731.7d0c9b45@infradead.org>
In-Reply-To: <4B11678D.8020601@majjas.com>
References: <4B106CC0.4050406@majjas.com>
	<20091128071808.GA32183@elte.hu>
	<20091128094530.0ede7b1a@infradead.org>
	<4B11678D.8020601@majjas.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Nov 2009 13:10:21 -0500
Michael Breuer <mbreuer@majjas.com> wrote:

> Ok - my only question then is why things appear so different with 
> intel_iommu enabled.

something else is even more expensive then :0


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
