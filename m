Return-Path: <linux-kernel-owner+w=401wt.eu-S932416AbYBHCul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbYBHCul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 21:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbYBHCuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 21:50:32 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:35000 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118AbYBHCub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 21:50:31 -0500
Message-ID: <47ABC375.5040103@davidnewall.com>
Date: Fri, 08 Feb 2008 13:20:29 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: =?UTF-8?B?SGFucy1Kw7xyZ2VuIEtvY2g=?= <hjk@linutronix.de>
CC: Christer Weinigel <christer@weinigel.se>,
       Marcel Holtmann <marcel@holtmann.org>,
       Diego Zuccato <diego@otello.alma.unibo.it>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>	<20080202123710.42df1aa0@weinigel.se>	<20080202191930.GA19826@kroah.com>	<47A5D895.20300@davidnewall.com>	<47A6E742.80408@otello.alma.unibo.it>	<47A764ED.8030605@weinigel.se>	<1202161091.15090.84.camel@violet>	<20080206213449.6614efea@weinigel.se>	<20080206215442.63c94cf3@dilbert.local>	<47AB056E.70802@davidnewall.com>	<20080207150612.21ba60df@dilbert.local>	<47AB163C.5070107@davidnewall.com>	<20080207171322.40eb7c95@dilbert.local>	<47AB36D2.5050602@davidnewall.com> <20080207184939.17030887@dilbert.local>
In-Reply-To: <20080207184939.17030887@dilbert.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-Jürgen Koch wrote:
> The license says that derivative work has to be GPL. Naturally, every
> sensible and practically usable license has gray areas. We know that
> and we live with that. But if there's room for interpretation, it's
> perfectly OK and helpful, if the copyright holder states what his
> interpretation is. If you use an EXPORT_SYMBOL_GPL symbol in non-GPL
> code, you know that the owner of the work doesn't agree with you
> license-wise.

How can an author form the opinion that another work is derivative, when
it hasn't even necessarily been written yet?

EXPORT_SYMBOL_GPL is no statement of the author's beliefs.  It's an
algorithm of restriction, and it affects original, non-derivative works.

>> It requires software that is *distributed* as part of a GPL
>> work to itself be GPL.  At time of distribution, a kernel module is
>> neither using nor linked to the kernel.
>>     
>
> Oh, come on! You cannot turn a derived work into an original work just
> by distributing them seperately.

That's not what I said.  From the start, I've made clear that I'm
talking of original, non-derivative works.  You said that mere linking
makes that non-derivative work derivative:

> Using a symbol from a library means linking to it, and that creates a
> derived work. Why should it be different when using kernel symbols?


This is wrong for the reasons I stated.
