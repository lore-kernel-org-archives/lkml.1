Return-Path: <linux-kernel-owner+w=401wt.eu-S1760624AbYBGUAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624AbYBGUAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbYBGUAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:00:40 -0500
Received: from floppyfw.timiskamingchildren.org ([209.226.88.42]:63234 "EHLO
	pennylane.tcafs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbYBGUAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:00:39 -0500
X-Greylist: delayed 1535 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Feb 2008 15:00:39 EST
Message-ID: <47AB5D2B.5010806@tcafs.org>
Date: Thu, 07 Feb 2008 14:34:03 -0500
From: Lee Mathers <Lee.Mathers@tcafs.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071229)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Diego Zuccato <diego@otello.alma.unibo.it>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>            <20080202123710.42df1aa0@weinigel.se>            <20080202191930.GA19826@kroah.com>            <47A5D895.20300@davidnewall.com>            <47A6E742.80408@otello.alma.unibo.it> <courier.47A8F072.000079E4@hawking.rebel.net.au> <47AAC1EE.6060101@otello.alma.unibo.it> <47AB0911.3060508@davidnewall.com>
In-Reply-To: <47AB0911.3060508@davidnewall.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> And it's a logical problem, too: why should the *driver* enforce a
>> *technical* limit?
>>     
> That's part of it's purpose.  It permits a manufacturer to make a global
> device that operates within local restrictions.
> --
>   

Then the hardware vendor needs to review there practices.  If you want 
to limit the ability of your technology do not include it.    I realize 
that this has become large revenue stream for many company's.   What 
they do not realize is that they have created a Wack-a-Mole situation.  
Just look at the Digital Satellite TV industry.

Companies used to Produce one logic board and selectively remove certain 
resistors or ic's to limit the end users ability.   The end user could 
still solder the missing chips etc to by  pass but much more 
difficult.   Way I see it is let the companies does as they please as 
they will bury themselves in the long run.

Now we have hardware ASIC that depend on the most part a (dll in 
windows) or .ko .o file under linux to provide the entire instruction 
set.  Think Winmodems,  Winprinters etc....
