Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbZLWSMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbZLWSMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 13:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756687AbZLWSMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 13:12:32 -0500
Received: from nat.nue.novell.com ([195.135.221.3]:35161 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756627AbZLWSMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 13:12:31 -0500
X-Greylist: delayed 1201 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Dec 2009 13:12:30 EST
Subject: Re: [Alacrityvm-devel] [GIT PULL] AlacrityVM guest drivers for
 2.6.33
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Avi Kivity <avi@redhat.com>, Gregory Haskins <gregory.haskins@gmail.com>,
       kvm@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       netdev@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091223121431.GF20539@basil.fritz.box>
References: <4B1D4F29.8020309@gmail.com> <87637zdy9g.fsf@basil.nowhere.org>
	 <4B30E654.40702@codemonkey.ws> <200912221701.56840.bzolnier@gmail.com>
	 <4B30F214.80206@codemonkey.ws> <20091223065129.GA19600@elte.hu>
	 <20091223101340.GC20539@basil.fritz.box> <4B31EF65.6070000@redhat.com>
	 <20091223121431.GF20539@basil.fritz.box>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Wed, 23 Dec 2009 10:52:19 -0700
Message-Id: <1261590740.19822.94.camel@hermosa>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-23 at 13:14 +0100, Andi Kleen wrote:
> > http://www.redhat.com/f/pdf/summit/cwright_11_open_source_virt.pdf
> >
> > See slide 32.  This is without vhost-net.
> 
> Thanks. Do you also have latency numbers?
> 
> It seems like there's definitely still potential for improvement
> with messages <4K. But for the large messages they indeed 
> look rather good.
> 
> It's unclear what message size the Alacrity numbers used, but I presume
> it was rather large.
> 

No.  It was 1500.  Please see: 

http://developer.novell.com/wiki/index.php/AlacrityVM/Results


Best,
-PWM


> -Andi

