Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbZISXTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbZISXTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 19:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZISXTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 19:19:13 -0400
Received: from outbound.icp-qv1-irony-out6.iinet.net.au ([203.59.1.109]:46493
	"EHLO outbound.icp-qv1-irony-out6.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841AbZISXTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 19:19:13 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Sep 2009 19:19:12 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoBAKcBtUp8qNxw/2dsb2JhbAAIy3qEGwU
X-IronPort-AV: E=Sophos;i="4.44,416,1249228800"; 
   d="scan'208";a="7920586"
Subject: Re: tickless and HZ=1000 throughput advantage?
From: Ben Nizette <bn@niasdigital.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2220909191050l19f2a446r5ccf1907fd963096@mail.gmail.com>
References: <6278d2220909190747n62f7036dj2e5231fcdc4730fb@mail.gmail.com>
	 <20090919165501.65d77294@infradead.org>
	 <6278d2220909191050l19f2a446r5ccf1907fd963096@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 20 Sep 2009 09:12:29 +1000
Message-Id: <1253401950.7587.7.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-19 at 18:50 +0100, Daniel J Blueman wrote:

> Agreed. Do you think there is still a small case for moving to HZ=1000
> (given it's effectively free) in situations like:

Sure HZ=1000 gives you more accurate sleeps, that's kind of the point,
but since when has it been "effectively free"?
http://lwn.net/Articles/331607/

	--Ben.

