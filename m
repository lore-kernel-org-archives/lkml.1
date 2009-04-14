Return-Path: <linux-kernel-owner+w=401wt.eu-S1758338AbZDNSzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338AbZDNSzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbZDNSzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:55:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:47762 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbZDNSzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:55:06 -0400
Subject: Re: [PATCH -tip] x86: cpu_debug.c prepare report if files are
 inappropriate or CPU is not supported
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090414184222.GC11214@elte.hu>
References: <1239725240.2966.4.camel@ht.satnam>
	 <20090414165052.GA2089@elte.hu> <1239728481.2966.21.camel@ht.satnam>
	 <20090414184222.GC11214@elte.hu>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 00:24:50 +0530
Message-Id: <1239735290.2966.29.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 20:42 +0200, Ingo Molnar wrote:
> > 
> > Do you still think that boot_cpu_data.x86_vendor is better option in
> > case for multiple CPUs.
> 
> yes. Assymetric SMP never really happened on x86.
> 

OK, it is late here, I will send cpu_debug patches tomorrow :-)

Thanks,
--
JSR

