Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbXFOUq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbXFOUq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbXFOUqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:46:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49750 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706AbXFOUqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:46:49 -0400
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexandre Oliva <aoliva@redhat.com>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
In-Reply-To: <alpine.LFD.0.98.0706151322070.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr>
	 <200706142144.15695.dhazelton@enter.net>
	 <1181895924.25228.319.camel@pmac.infradead.org>
	 <200706150458.29943.dhazelton@enter.net>
	 <1181899064.25228.342.camel@pmac.infradead.org>
	 <alpine.LFD.0.98.0706150846370.14121@woody.linux-foundation.org>
	 <1181930204.25228.590.camel@pmac.infradead.org>
	 <alpine.LFD.0.98.0706151118150.14121@woody.linux-foundation.org>
	 <1181936955.5211.62.camel@shinybook.infradead.org>
	 <alpine.LFD.0.98.0706151322070.14121@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 21:47:03 +0100
Message-Id: <1181940425.5211.81.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 13:34 -0700, Linus Torvalds wrote:
> I think that's a somewhat valid argument, although I'm not really sure 
> whether there is any difference between, say, a Fedora 7 "livecd", and a 
> router with a cramfs filesystem in rom.
> 
> Both really work the same way, and both really are very much targeted 
> towards a specific hardware platform.

I'm inclined to agree. And I'd probably suggest that the Fedora 7
'livecd' would be in violation of the GPL if it were to include the
binary-only modules, too. Enough people agree with me that we _don't_ in
fact include those modules. And other people have been convinced to
_stop_ shipping those modules, when once they did.

> So I would at least *personally* suggest that people not look into the 
> license for these kinds of things, and also that you really need to have a 
> very specific case, and just basically put it in front of a judge.

> At some point, *somebody* has to decide in a gray area, and I'm not saying 
> that a judge is really _technically_ any better really to decide the 
> issue, but at least he is hopefully _independent_ of both parties, so when 
> a judge makes an arbitrary decision, the "arbitrariness" is hopefully at 
> least somewhat "fair".

Indeed.

-- 
dwmw2

