Return-Path: <linux-kernel-owner+w=401wt.eu-S932641AbZKDVRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbZKDVRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932630AbZKDVRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:17:52 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:59093 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbZKDVRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:17:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=OhT8WIQmPjo0QEqDuQfWVdVmqLuJlGqJURYnS1znrTl71jPgyuarNh+2TXwzKUiQY0
         J8BrkM+7T6cGSAXbqZGIChcod2L1lV5wNjbdp/bo+RAoU8XictogxzBWhlIr9rxXP6aq
         D/coVf7QDv2Ze7BNFlbZzHsuGFKmSHoUGicz8=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: pull request: wireless-next-2.6 2009-10-28
Date: Wed, 4 Nov 2009 22:17:48 +0100
User-Agent: KMail/1.9.10
Cc: Pavel Machek <pavel@ucw.cz>, Luis Correia <luis.f.correia@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1256886023.3555.5.camel@johannes.local> <20091102211629.GA1322@ucw.cz> <alpine.LRH.2.00.0911041403480.31913@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.0911041403480.31913@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911042217.49144.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Jiri Kosina wrote:
> On Mon, 2 Nov 2009, Pavel Machek wrote:
> 
> > > I've searched on my GMail archives and the only patch Bart has
> > > provided so far for the rt2x00 project is this:
> > > 
> > > [PATCH] MAINTAINERS: rt2x00 list is moderated
> > > 
> > > Which, while technically correct, adds nothing to the project.
> > > 
> > > So, I will personally continue to ignore Bart's comments, regards and
> > > rants, until he provides patches for rt2x00 that actually make the
> > > driver better.
> > 
> > Well, he provided review feedback... he should be thanked for that,
> > not flamed for it.
> 
> He has actually written real patches (and quite non-trivial both in amount 
> and in functionality), see
> 
> 	http://lkml.org/lkml/2009/11/3/372

Please look at the TIMESTAMP of the mail you refer to, and the TIMESTAMP
of the mail from Luis. And then you can make assumptions about the text...

> But yes, he got flamed for this for some odd reason. I got the impression 
> that the community around rt2x00 doesn't like (or understand) the way how 
> opensource development happens.

Well you mean the open source development where non-contributors
complain that the contributors work too slowly? Well if that is the way
things should go, then I don't want to be part of such idiocy. Perhaps
that is the policy in some companies which try to import it into the
Open Source world...

Ivo
