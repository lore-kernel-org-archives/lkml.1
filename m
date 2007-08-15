Return-Path: <linux-kernel-owner+w=401wt.eu-S1762303AbXHOBio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762303AbXHOBio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 21:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbXHOBib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 21:38:31 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1111 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbXHOBia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 21:38:30 -0400
Subject: Re: [PATCH] [121/2many] MAINTAINERS - CFG80211 and NL80211
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: torvalds@linux-foundation.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <1187000365.27916.66.camel@johannes.berg>
References: <46bff948.otglyA7i5BhTYKIi%joe@perches.com>
	 <1187000365.27916.66.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 18:37:41 -0700
Message-Id: <1187141862.32555.184.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 12:19 +0200, Johannes Berg wrote:
> On Sun, 2007-08-12 at 23:25 -0700, joe@perches.com wrote:
> > Add file pattern to MAINTAINER entry
> 
> > +F:	include/linux/nl80211.h
> > +F:	include/net/cfg80211.h
> > +F:	net/wireless/core.*
> > +F:	net/wireless/sysfs.*
> > +F:	net/wireless/radiotap.c
> 
> I must've missed the original discussion surrounding this,

Sorry, posted 1/way2many on LK.
http://lkml.org/lkml/2007/8/13/17

> are these supposed to be regular match patterns?

More or less.  

> Is there a tool reading it? With
> this and wireless extensions it'd probably be best to mark cfg80211 as
> "everything in net/wireless/ but net/wireless/wext*" if possible.

CFG80211 and NL80211
P:	Johannes Berg
M:	johannes@sipsolutions.net
L:	linux-wireless@vger.kernel.org
S:	Maintained
F:	include/linux/nl80211.h
F:	include/net/cfg80211.h
F:	net/wireless/*
X:	net/wireless/wext*


