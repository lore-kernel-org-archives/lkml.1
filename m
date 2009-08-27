Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbZH0U7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbZH0U7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 16:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbZH0U7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 16:59:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45755 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbZH0U7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 16:59:13 -0400
Message-ID: <4A96F355.30808@kernel.org>
Date: Thu, 27 Aug 2009 13:57:57 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Dave Young <hidave.darkstar@gmail.com>, webmaster@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, stable@kernel.org
Subject: Re: mm/-next release on kernel.org web page?
References: <a8e1da0908020056mbf28eaw611c605693eb3eff@mail.gmail.com>	<20090802095523.e08166e3.rdunlap@xenotime.net>	<a8e1da0908021908x8216693k7fb31bc5b58d6666@mail.gmail.com>	<20090802193045.c3f3195c.rdunlap@xenotime.net>	<4A766F39.7090903@kernel.org>	<4A95D677.2020807@kernel.org>	<a8e1da0908270739sbab4821x6ec402a72587a337@mail.gmail.com> <20090827124315.0d0f2129.rdunlap@xenotime.net>
In-Reply-To: <20090827124315.0d0f2129.rdunlap@xenotime.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.1.1 (shards.monkeyblade.net [198.137.202.13]); Thu, 27 Aug 2009 13:57:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Is it possible to add latest mmotm link?
>> Just link to andrew's broken-out.tar.gz with the stamp name?
> 
> Ditto.  Please.

Problem with mmotm is that Andrew is hosting that out of his public_html 
directory, which I can only assume means that the tree isn't intended to 
be consumed by the masses, as official trees are supposed to live under 
/pub.  If this is not the case then we need to get it moved under 
/pub/scm & /pub as things on public_html aren't synced out to the 
front-end machines.  But I will have to defer to Andrew on what 
direction he wants to take mmotm.

- John 'Warthog9' Hawley
