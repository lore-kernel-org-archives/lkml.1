Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbZGYC14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbZGYC14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 22:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbZGYC14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 22:27:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46727 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbZGYC1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 22:27:55 -0400
X-Greylist: delayed 2211 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jul 2009 22:27:55 EDT
Message-ID: <4A6A64CB.7090108@kernel.org>
Date: Fri, 24 Jul 2009 18:50:03 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
CC: Greg KH <gregkh@suse.de>, webmaster@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: Linux 2.6.27.28
References: <20090724222746.GA30562@kroah.com> <4A6A48A1.80608@tremplin-utc.net>
In-Reply-To: <4A6A48A1.80608@tremplin-utc.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.1.1 (shards.monkeyblade.net [198.137.202.13]); Fri, 24 Jul 2009 18:50:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Éric Piel wrote:
> Op 25-07-09 00:27, Greg KH schreef:
>> I'm announcing the release of the 2.6.27.28 kernel.  It fixes a
>> boot-time error with the 2.6.27.27 release.  If you don't have this
>> problem, no need to upgrade.
>>
>> I'll also be replying to this message with a copy of the patch between
>> 2.6.27.27 and 2.6.27.28
>>
>> The updated 2.6.27.y git tree can be found at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
>> and can be browsed at the normal kernel.org git web browser:
>>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary
>>
> Hello,
> Currently, there is no clue on www.kernel.org that 2.6.27 is a "long
> term stable" kernel tree. Would it be possible to add a line to the page
> pointing to the latest version of this type of tree? I'm sure some
> people would love discovering that such thing exists :-)

Eric, Everyone,

Yes we know about this problem, the code that generates the numbers on 
the front page is really quite ancient (and thus any assumption we had 
back when it was written is anything but the same now) and we have been 
working on getting it updated.  However there has been a lot going on, 
Fedora's recent excitement, Linux Symposium, OSCon, etc and work on this 
has been disrupted and scattered - I.E. I haven't gotten very far on it 
yet :-(

I'm hoping to get back onto it next week, but please bear with us while 
we try and get it all sorted out and try and get the code into such a 
shape that we can actually cope with the ever changing idea of what are 
'latest' kernels are now, and going forward.

- John 'Warthog9' Hawley
