Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbZIWPyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbZIWPyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZIWPyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:54:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752696AbZIWPyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:54:50 -0400
Date: Wed, 23 Sep 2009 08:53:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       jan.kratochvil@redhat.com, Oleg Nesterov <oleg@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] x86: clean up orig_ax handling
In-Reply-To: <20090923154118.GB6105@elte.hu>
Message-ID: <alpine.LFD.2.01.0909230852530.4950@localhost.localdomain>
References: <20090923004651.2D99513F37@magilla.sf.frob.com> <alpine.LFD.2.01.0909221757200.4950@localhost.localdomain> <20090923024049.AA85913F37@magilla.sf.frob.com> <20090923061834.BE13A22@magilla.sf.frob.com> <20090923154118.GB6105@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Sep 2009, Ingo Molnar wrote:
> 
> Linus, this series looks good to me. Do you want to pull this directly 
> or should we test this for a few days in the x86 tree? (either solution 
> is fine to me)

I already pulled it, since I'm used to pulling ptrace fixes from Roland,

		Linus
