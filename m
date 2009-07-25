Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbZGYHey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbZGYHey (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 03:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZGYHey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 03:34:54 -0400
Received: from er-systems.de ([85.25.136.202]:43125 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbZGYHex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 03:34:53 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Jul 2009 03:34:53 EDT
Date: Sat, 25 Jul 2009 09:25:21 +0200 (CEST)
From: Thomas Voegtle <tv@lio96.de>
To: Greg KH <gregkh@suse.de>
cc: =?ISO-8859-15?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>,
       webmaster@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: Linux 2.6.27.28
In-Reply-To: <20090725033030.GA481@suse.de>
Message-ID: <alpine.LNX.2.00.0907250906330.10172@er-systems.de>
References: <20090724222746.GA30562@kroah.com> <4A6A48A1.80608@tremplin-utc.net> <20090725033030.GA481@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="425052808-535022048-1248506723=:10172"
X-Virus-Checker-Version: clamassassin 1.2.4 with clamdscan / ClamAV 0.95.2/9613/Sat Jul 25 02:08:58 2009 signatures .
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--425052808-535022048-1248506723=:10172
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT


Hi,

first of all: thank you for the stable kernels...


On Fri, 24 Jul 2009, Greg KH wrote:
> On Sat, Jul 25, 2009 at 01:49:53AM +0200, Éric Piel wrote:
>> Currently, there is no clue on www.kernel.org that 2.6.27 is a "long
>> term stable" kernel tree. Would it be possible to add a line to the page
>> pointing to the latest version of this type of tree? I'm sure some
>> people would love discovering that such thing exists :-)
>
> I'm curious as to why someone, if they were inclined to be using such a
> thing, wouldn't already know about this?

It even isn't called at linux-kernel-announce, except the latest stable 
kernel.
So you have to read LKML, or follow the lwn.net news to track the 
older stable kernel. Or always guessing: when there is a release of the 
newer stable kernel (this is announced in linux-kernel-announce) then 
there might be a release of the older one aswell...


> How many people really are relying on this .27 branch, becides the
> distros, these days?  And if you are, why?

I'm one of that guys, having a server and one firewall and feeling 
much better with a small optimized own-built kernel for that machines.
And both just work with this .27 branch, why should I change it to 
2.6.30.y?
I don't need any of the new features and it won't be faster with 2.6.30 or 
something else...


       Thomas

--425052808-535022048-1248506723=:10172--

