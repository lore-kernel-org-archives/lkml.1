Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbZIZTfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbZIZTfh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 15:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZIZTfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 15:35:36 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:51424 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbZIZTfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 15:35:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Rrf1hvxYRtq8bMu5P4EftnGGlfmIlF4QLOTH5LeVbeYX03K2yENeJpuWe07qwQAIGq
         zNu1PstANxghZJwCplUhNfR33kTJqVHZJ1VMM0pig2jgbS3/6lOdsmjT2FCzqvcBuUHL
         9UguHrf7REO7GdR7Mez/mf0Gvuu2YeCUjMB7w=
Date: Sat, 26 Sep 2009 23:35:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       netdev@vger.kernel.org
Subject: Re: [PATCH 9/9] Add explicit bound checks in net/socket.c
Message-ID: <20090926193538.GC4356@lenovo>
References: <20090926204951.424e567e@infradead.org> <20090926205432.24aa1023@infradead.org> <20090926190103.GB4356@lenovo> <20090926212302.0ce64a5c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926212302.0ce64a5c@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Arjan van de Ven - Sat, Sep 26, 2009 at 09:23:02PM +0200]
...
| 
| goof once goof twice, make it sizeof.. that's nicer.
| 

yeah, I was about to propose the same :)

...
	- Cyrill
