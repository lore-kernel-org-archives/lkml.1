Return-Path: <linux-kernel-owner+w=401wt.eu-S1761427AbXHACBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761427AbXHACBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 22:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbXHACBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 22:01:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37852 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbXHACBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 22:01:03 -0400
Message-ID: <46AFE77F.90505@zytor.com>
Date: Tue, 31 Jul 2007 21:53:03 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: Zwane Mwaikambo <zwane@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
References: <4678191D.76E4.0078.0@novell.com> <4686D85B.6090803@gentoo.org> <20070630154230.4ad373fa.akpm@linux-foundation.org> <4690E65B.5050607@gentoo.org> <20070708111404.1486e73c.akpm@linux-foundation.org> <46912E09.2070806@zytor.com> <4692BC61.9070500@gentoo.org> <4692BDEE.8020802@zytor.com> <4693BF02.2050705@gentoo.org> <4693C0A1.8010901@zytor.com> <4693CAFF.4000609@gentoo.org> <4693CCC6.7050400@zytor.com> <46AFCCBB.70307@gentoo.org> <Pine.LNX.4.64.0707311719540.5207@montezuma.windriver.com> <46AFDF3A.6080300@gentoo.org>
In-Reply-To: <46AFDF3A.6080300@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake wrote:
> Zwane Mwaikambo wrote:
>> Sorry if this has been hashed out before, but could you point me 
>> towards the gentoo bugzilla entry? I'm trying to understand how your 
>> setup broke. Which version VBE does your system have?
> 
> Here's the bug:
> http://bugs.gentoo.org/show_bug.cgi?id=181067
> 
> How can we identify the VBE version?
> 
> Thanks,
> Daniel

Just put printf's in video-vesa.c

	-hpa
