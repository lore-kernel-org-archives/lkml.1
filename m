Return-Path: <linux-kernel-owner+w=401wt.eu-S1763452AbYARRUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763452AbYARRUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761050AbYARRUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:20:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757487AbYARRUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:20:04 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr patch series v3)
Date: Fri, 18 Jan 2008 18:19:58 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, jbeulich@novell.com,
       venkatesh.pallipadi@intel.com
References: <200801161114.239449000@suse.de> <200801181734.51193.ak@suse.de> <20080118164853.GA17589@elte.hu>
In-Reply-To: <20080118164853.GA17589@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181819.58675.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> i pointed it out how to port a larger series ontop of a whitespace 
> cleanup patch:
> 
>  http://lkml.org/lkml/2008/1/18/281
> 
> the "there's an easy technique" bit.

But it will be even easier to just redo the cleanup stuff at the
end. If I do what you describe here I'm sure I will make a mistake
somewhere and I would rather not risk that.

-Andi
