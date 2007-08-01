Return-Path: <linux-kernel-owner+w=401wt.eu-S1763677AbXHABTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763677AbXHABTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759000AbXHABTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:19:14 -0400
Received: from smtp111.iad.emailsrvr.com ([207.97.245.111]:51191 "EHLO
	smtp111.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501AbXHABTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:19:14 -0400
Message-ID: <46AFDF3A.6080300@gentoo.org>
Date: Tue, 31 Jul 2007 21:17:46 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: Zwane Mwaikambo <zwane@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
References: <4678191D.76E4.0078.0@novell.com> <4686D85B.6090803@gentoo.org> <20070630154230.4ad373fa.akpm@linux-foundation.org> <4690E65B.5050607@gentoo.org> <20070708111404.1486e73c.akpm@linux-foundation.org> <46912E09.2070806@zytor.com> <4692BC61.9070500@gentoo.org> <4692BDEE.8020802@zytor.com> <4693BF02.2050705@gentoo.org> <4693C0A1.8010901@zytor.com> <4693CAFF.4000609@gentoo.org> <4693CCC6.7050400@zytor.com> <46AFCCBB.70307@gentoo.org> <Pine.LNX.4.64.0707311719540.5207@montezuma.windriver.com>
In-Reply-To: <Pine.LNX.4.64.0707311719540.5207@montezuma.windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zwane Mwaikambo wrote:
> Sorry if this has been hashed out before, but could you point me towards 
> the gentoo bugzilla entry? I'm trying to understand how your setup broke. 
> Which version VBE does your system have?

Here's the bug:
http://bugs.gentoo.org/show_bug.cgi?id=181067

How can we identify the VBE version?

Thanks,
Daniel
