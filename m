Return-Path: <linux-kernel-owner+w=401wt.eu-S1758311AbYBXEZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbYBXEZs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 23:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYBXEZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 23:25:39 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:32948 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbYBXEZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 23:25:38 -0500
Message-ID: <47C0E217.8070801@davidnewall.com>
Date: Sun, 24 Feb 2008 13:48:47 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
References: <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org> <m3tzk1q3rt.fsf@maximus.localdomain> <47BE0C12.604@garzik.org> <m3k5kxq2ih.fsf@maximus.localdomain> <20080222184518.GB6060@ucw.cz> <m3zlts393a.fsf@maximus.localdomain> <20080223094334.GA3081@elf.ucw.cz> <47C013E2.6040201@davidnewall.com> <20080223152522.GA4287@ucw.cz>
In-Reply-To: <20080223152522.GA4287@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sat 2008-02-23 23:08:58, David Newall wrote:
>   
>> Pavel Machek wrote:
>>     
>>> On Fri 2008-02-22 23:44:09, Krzysztof Halasa wrote:
>>>   
>>>       
>>>> Pavel Machek <pavel@ucw.cz> writes:
>>>>
>>>>     
>>>>         
>>>>> Zaurus is one example, second is small screen where you need big font
>>>>> to keep it readable (x60 on desk).
>>>>>       
>>>>>           
>>>> Come on, are you doing Linux kernel development on PDA?
>>>>         
>
> Actually, I'd like to. There's a lot to fix on zaurus. Bit corruption
> while sleeping is high on list, but I guess I should move out of
> 2.6.16, first.
>
>   
>>> I review patches on it, sometimes, yes.
>>>   
>>>       
>> Do you actually get 80 columns wide on it?
>>     
>
> No, something like 62... but it is usually enough. x60 is about 100
> columns wide (big font needed).

Then it's a silly example to raise in a serious discussion of this type.
