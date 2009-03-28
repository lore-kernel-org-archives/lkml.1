Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbZC1Bwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbZC1Bwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 21:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbZC1Bw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 21:52:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbZC1Bw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 21:52:28 -0400
Date: Fri, 27 Mar 2009 18:45:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49CD6CE6.3020309@garzik.org>
Message-ID: <alpine.LFD.2.00.0903271840450.3994@localhost.localdomain>
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk>
 <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
 <49CD2C47.4040300@garzik.org> <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain> <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <49CD6CE6.3020309@garzik.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Mar 2009, Jeff Garzik wrote:
> 
> Definitely a difference!   1 for both, here.  Deb is a fresh OS install and
> fresh homedir, but my F10 has been through many OS and ff config upgrades over
> the years.

Hmm. I wonder where firefox gets its defaults then. 

I can well imagine that Debian has a different firefox build, with 
different defaults. But if your F10 thing also is set to 1, and still 
shows as "default", then that's odd, considering that mine shows 0.

I have 'rpm -q firefox': firefox-3.0.7-1.fc10.x86_64.

Is yours a 32-bit one? Maybe it comes with different defaults?

And maybe firefox just has a very odd config setup and I don't understand 
what "default" means at all. Gene says he doesn't have that 
toolkit.storage.synchronous thing at all.

		Linus

