Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbYHFKHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbYHFKHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 06:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYHFKGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 06:06:38 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:51047 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbYHFKGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 06:06:37 -0400
In-Reply-To: <20080805202621.GA27489@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a	linuxinterfaceforon	access
 scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Wed, 6 Aug 2008 11:05:43 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 11:06:31,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 11:06:31,
	Serialize complete at 06/08/2008 11:06:31,
	S/MIME Sign failed at 06/08/2008 11:06:31: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/08/2008 11:05:46,
	Serialize complete at 06/08/2008 11:05:46
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080806100638.9FD672FE8E3@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote on 05/08/2008 21:26:21:

> > [JON PRESS]  I wouldn't call it lazy, actually.  It's more like
> > "economical" or "ergonomic" -- or, dare I say it -- "user-friendly." 
In
> > this case, the users are the AV vendors who will have to write to the
> > API that will come out of this spec.  We will be more inclined to
> > appreciate the SDK (for want of a better term) if it covers all the
> > bases, rather than force us to go elsewhere for some of our
> > requirements.  When we write SDKs, we try to make sure that our users
> > will find whatever they need.
> 
> But realize that you are adding an overhead on us, the kernel community,
> to make your life easier.  We are the ones that are taking our time to
> review and comment on this code.  We are the ones who will have to live
> with this code for forever, and maintain it over the lifetime of linux.
> So far, you all have shown no willingness to give anything back to us at
> all.

We all? How is that true? I for example wrote some code and am willing to 
help maintain it if it gets accepted. And as you describe it, it would be 
true for any submission because not all things are usefull for all people, 
while everything is baggage for the community. And who is the community? I 
thought all who take place in discussions, bug reporting, submitting code, 
fixing bugs etc are the community.

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

