Return-Path: <linux-kernel-owner+w=401wt.eu-S933421AbZC0AmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421AbZC0AmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933399AbZC0Alz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:41:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932736AbZC0Alx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:41:53 -0400
Date: Thu, 26 Mar 2009 17:30:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frans Pop <elendil@planet.nl>
cc: alan@lxorguk.ukuu.org.uk, mjg@redhat.com, tytso@mit.edu, mingo@elte.hu,
       jack@suse.cz, akpm@linux-foundation.org, arjan@infradead.org,
       a.p.zijlstra@chello.nl, npiggin@suse.de, jens.axboe@oracle.com,
       drees76@gmail.com, jesper@krogh.cc, linux-kernel@vger.kernel.org,
       oleg@redhat.com, roland@redhat.com
Subject: Re: [PATCH 2/2] Make relatime default
In-Reply-To: <200903270115.32071.elendil@planet.nl>
Message-ID: <alpine.LFD.2.00.0903261728170.3994@localhost.localdomain>
References: <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu>
 <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326170714.GF6239@mit.edu> <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain> <20090326174956.GB7198@srcf.ucam.org> <20090326175314.GC7198@srcf.ucam.org> <20090326184838.26166549@lxorguk.ukuu.org.uk>
 <20090326184838.26166549@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0903261525560.3032@localhost.localdomain> <200903270115.32071.elendil@planet.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Mar 2009, Frans Pop wrote:
> 
> I guess users and distros can still elect not to set it as default, but it 
> still seems a bit like going from one extreme to another.

Why? RELATIME has been around since 2006 now. Nothing has happened. People 
who think "we should leave it up to user land" lost their credibility long 
ago.

			Linus
