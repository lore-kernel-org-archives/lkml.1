Return-Path: <linux-kernel-owner+w=401wt.eu-S1761777AbZC1AT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761777AbZC1AT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZC1ATS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:19:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53324 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbZC1ATR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:19:17 -0400
Message-ID: <49CD6CE6.3020309@garzik.org>
Date: Fri, 27 Mar 2009 20:18:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain> <49CD2C47.4040300@garzik.org> <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain> <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 27 Mar 2009, Jeff Garzik wrote:
>> What is in Fedora 10 and Debian lenny's iceweasel both definitely sync to
>> disk, as of today, according to my own tests.
> 
> Hmm. Go to "about:config" and check your "toolkit.storage.synchronous" 
> setting.
> 
> It _should_ say
> 
> 	default integer 0
> 
> and that is what it says for me (yes, on Fedora 10).
> 
> The values are: 0 = off, 1 = normal, 2 = full.

Definitely a difference!   1 for both, here.  Deb is a fresh OS install 
and fresh homedir, but my F10 has been through many OS and ff config 
upgrades over the years.

	Jeff



