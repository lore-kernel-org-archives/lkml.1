Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbXFLMFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbXFLMFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbXFLMFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:05:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42660 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261AbXFLMFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:05:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: beeping patch for debugging acpi sleep
Date: Tue, 12 Jun 2007 14:11:55 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Christian Leber <christian@leber.de>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20070518213701.GA810@core> <20070611120034.f6d972de.akpm@linux-foundation.org> <1181601771.5064.2.camel@nigel.suspend2.net>
In-Reply-To: <1181601771.5064.2.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706121411.56016.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, 12 June 2007 00:42, Nigel Cunningham wrote:
> Hi.
> 
> Wouldn't it be much more useful if it was unconditionally compiled in
> and controlled instead by a sysfs entry? That way it will be far more
> useful to $user who doesn't know or want to know how to compile and
> install a kernel, but wants to do what they can to get provide helpful
> debugging info and perhaps even get it going.

I like this idea.

> Yes, Pavel, I'll supply a patch if you (plural) agree.

I agree.  :-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
