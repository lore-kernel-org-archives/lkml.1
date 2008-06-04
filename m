Return-Path: <linux-kernel-owner+w=401wt.eu-S1760663AbYFDPhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760663AbYFDPhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbYFDPg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:36:59 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:30096 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbYFDPg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:36:58 -0400
X-BigFish: VPS-32(z34a4nz1432R98dR7efV1805Mzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4846B656.6030707@am.sony.com>
Date: Wed, 4 Jun 2008 08:35:50 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
 translation
References: <48447615.5050806@am.sony.com>	 <1212500751.16924.322.camel@pmac.infradead.org>	 <4845DB46.3020308@am.sony.com> <1212538597.4042.29.camel@shinybook.infradead.org>
In-Reply-To: <1212538597.4042.29.camel@shinybook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2008 15:36:11.0914 (UTC) FILETIME=[B78FDEA0:01C8C658]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Tue, 2008-06-03 at 17:01 -0700, Tim Bird wrote:
>> This is clearly an improvement. But it is missing this part of the
>> original patch:
> 
> Oops, well spotted. I've updated the patch in the git tree; thanks.
> 
> (that's what comes of applying patches by hand -- I _knew_ I had to do
> that hunk, but managed to forget about it within the space of about 30
> seconds when I was doing the other parts. I plead stupidity)

We can chalk it up to my stupidity for sending a patch
that couldn't be applied automatically...
Thanks very much for the improvements!
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

