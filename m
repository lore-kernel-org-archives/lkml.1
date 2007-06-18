Return-Path: <linux-kernel-owner+w=401wt.eu-S1764853AbXFRSeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764853AbXFRSeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761276AbXFRSd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:33:58 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:59024
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761382AbXFRSd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:33:57 -0400
Date: Mon, 18 Jun 2007 11:32:41 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alexandre Oliva <aoliva@redhat.com>
cc: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Bron Gondwana <brong@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <orabuxcefc.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <Pine.LNX.4.64.0706181122410.12717@asgard.lang.hm>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
 <200706161817.36657.dhazelton@enter.net> <orodjfmjsr.fsf@oliva.athome.lsd.ic.unicamp.br>
 <200706162306.14516.dhazelton@enter.net> <orwsy3l0jv.fsf@oliva.athome.lsd.ic.unicamp.br>
 <20070617051451.GD21478@ftp.linux.org.uk> <orps3vjf93.fsf@oliva.athome.lsd.ic.unicamp.br>
 <20070618154549.GB6041@kroah.com> <orabuxcefc.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

do you realize that redhat uses checksums or signatures to check the 
validity of their CD's?

try to burn a redhat image with the -pad option which adds a chunk of 0's 
to the end of the image and try to boot it.

I seriously doubt if redhat tells you how to how to generate such a 
checksum/signature.

in addition to the problem that Linus points out about being unable to 
change the contents of the write-only CD this would seem to conflict with 
what you are claiming the GPL is supposed to allow.

David Lang
