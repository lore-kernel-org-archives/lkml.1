Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbZC1CQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbZC1CQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 22:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbZC1CQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 22:16:13 -0400
Received: from rtr.ca ([76.10.145.34]:46138 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbZC1CQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 22:16:12 -0400
Message-ID: <49CD8868.20807@rtr.ca>
Date: Fri, 27 Mar 2009 22:16:08 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain> <49CD2C47.4040300@garzik.org> <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain> <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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
..
> If you don't have that "toolkit.storage.synchronous" entry, that means 
> that you have an older version of firefox-3.
..


Okay, I'll bite.  Exactly which version of FF has that variable?
Cuz it ain't in the FF 3.0.8 that I'm running here.

Thanks
