Return-Path: <linux-kernel-owner+w=401wt.eu-S1751519AbXBFPNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbXBFPNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 10:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbXBFPNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 10:13:05 -0500
Received: from mail.tmr.com ([64.65.253.246]:35094 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbXBFPNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 10:13:04 -0500
Message-ID: <45C89AC4.7050708@tmr.com>
Date: Tue, 06 Feb 2007 10:12:04 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Stefan Seyfried <seife@suse.de>
CC: Adrian Bunk <bunk@stusta.de>, Greg KH <greg@kroah.com>,
       Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <20070131011340.GP3754@stusta.de> <20070131012428.GA31759@kroah.com> <20070131021431.GR3754@stusta.de> <20070205094947.GA32384@suse.de>
In-Reply-To: <20070205094947.GA32384@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Seyfried wrote:
> On Wed, Jan 31, 2007 at 03:14:31AM +0100, Adrian Bunk wrote:
>> On Tue, Jan 30, 2007 at 05:24:28PM -0800, Greg KH wrote:
> 
>>> What?  Throw a fresh-faced newbie instantly into the tar-pit of despair
>>> that floppy.c is?  Do you want everyone just to run screaming from
>>> kernel development never to be seen again?
>>>
>>> :)
>> Other than with the ISA drivers example, at least everyone has the 
>> hardware... ;-)
> 
> Wrong. I abandoned all floppy drives some years ago. I'd actually
> vote for removing the floppy driver from the kernel completely.

Is that your model of how the kernel should work? Take out anything you 
don't personally need?

I'm guesstimating the 20-30% of the old laptops I rehab on Linux for 
kids who have none lack the ability to boot off CD. Or write a CD, for 
that matter. The ability of Linux to run on old hardware is another 
advantage over commercial systems.
> 
> Well, at work i probably have an USB floppy lying around somewhere,
> but i doubt that it uses floppy.c ;-), 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
