Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbXFNU34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbXFNU34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbXFNU3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:29:46 -0400
Received: from ag-out-0708.google.com ([72.14.246.241]:44340 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbXFNU3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:29:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=YI/5WKrDboGm4keZayrHg4IiblSP5I5zvi9wqZAhDXJ81duo5ZARNXBNDW0yFvare7pb0zx/b2aehFboNGRMpnmUCu0uq8aPun0osTYiFDCgZYh4r1Rk+GzVLnh2Iu62PokkrNnDxKKXHrlpk3T0Ak9B5UfjZKoB+6k+o2BZY6I=
Message-ID: <4671A528.5040300@gmail.com>
Date: Thu, 14 Jun 2007 16:29:28 -0400
From: Florin Malita <fmalita@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Alexandre Oliva <aoliva@redhat.com>
CC: Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>	<alpine.LFD.0.98.0706131957440.14121@woody.linux-foundation.org>	<ortztbgi03.fsf@oliva.athome.lsd.ic.unicamp.br>	<200706140305.50095.dhazelton@enter.net>	<orr6oefpg4.fsf@oliva.athome.lsd.ic.unicamp.br>	<46717C58.8050501@gmail.com> <ord4zye6iv.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <ord4zye6iv.fsf@oliva.athome.lsd.ic.unicamp.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2007 02:27 PM, Alexandre Oliva wrote:
>> No, by this twisted logic Tivo *cannot* modify that particular copy
>> any more than you can. They can modify *another* copy (just like you)
>> and they can *replace* the copy in your device with the new version
>> (unlike you).
>>     
>
> Again, replacing is one form of modification.
>   

No, it's not: replacing does not create derivative work. Modification does.

You've chosen to attach a physical dimension to "program copy" and I'm 
arguing that even under this distorted line of reasoning you can't 
support your position:

> The customer gets the copy that TiVO stored in the hard disk in
> the device it sells.  And it's that copy that the customer is entitled
> to modify because TiVO is still able to modify it.

* Tivo takes public sources, modifies them and builds a brand new blob
* Tivo installs this new copy on the device, most likely side-by-side 
with the old one - notice how the new copy is derived from public 
sources and has absolutely nothing to do with the old version (heck, it 
can be a totally different kernel for what it's worth)
* Tivo deletes the old copy from the device

It seems pretty obvious that the only right Tivo is withholding is the 
right to install new versions on the device - they never do (and really 
never could) "modify" the physical copy on your device (which is your 
main argument).


> What do you think you do when you save a modified source file in your
> editor?

Don't skip the part where the in-memory version started as an exact copy 
of the original being replaced. Notice the difference? ;)

---
fm


