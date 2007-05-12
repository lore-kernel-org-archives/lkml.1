Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbXELSV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbXELSV3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXELSVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:21:23 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53788 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbXELSVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:21:23 -0400
Message-ID: <464604A6.8010607@zytor.com>
Date: Sat, 12 May 2007 11:17:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
       "YOSHIFUJI Hideaki / ?$B5HF#1QL@" <yoshfuji@linux-ipv6.org>,
       jengelh@linux01.gwdg.de, linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.21-gitN - versioning question
References: <Pine.LNX.4.61.0705121316540.9570@yvahk01.tjqt.qr>	 <20070512.210308.93070730.yoshfuji@linux-ipv6.org>	 <20070512131906.GF8337@cvg> <1178977496.2802.5.camel@shinybook.infradead.org>
In-Reply-To: <1178977496.2802.5.camel@shinybook.infradead.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Sat, 2007-05-12 at 17:19 +0400, Cyrill Gorcunov wrote:
>> Actually I think it would be convenient if such tags (like
>> v.2.6.21-git16) were in Linus' git tree too.
> 
> Then there would be _lots_ of tags in the master tree -- I'm not sure we
> want that.
> 
> I suppose I could put a tree on kernel.org which _does_ have the tags,
> and which precisely matches Linus' tree in every other way... but then
> again, you could do that too by just rsyncing the tags yourself :)

I think that would be a great idea.  It would hardly take up any space
with proper use of alternates.

	-hpa
