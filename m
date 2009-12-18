Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbZLRPyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbZLRPyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbZLRPyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:54:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:47973 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbZLRPys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:54:48 -0500
Subject: Re: workqueue thing
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, mingo@elte.hu, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org
In-Reply-To: <alpine.LFD.2.00.0912180747030.3712@localhost.localdomain>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
	 <1261143924.20899.169.camel@laptop>
	 <alpine.LFD.2.00.0912180724580.3712@localhost.localdomain>
	 <1261150788.20899.299.camel@laptop>
	 <alpine.LFD.2.00.0912180747030.3712@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 16:53:20 +0100
Message-ID: <1261151600.20899.316.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 07:47 -0800, Linus Torvalds wrote:
> 
> On Fri, 18 Dec 2009, Peter Zijlstra wrote:
> > 
> > That's exactly what it does..
> > 
> > 4e6045f134784f4b158b3c0f7a282b04bd816887
> > eb13ba873881abd5e15af784756a61af635e665e
> > a67da70dc0955580665f5444f318b92e69a3c272
> 
> Ahh. Never even triggered my "I've seen those patches".

Hehe, with the volume going through these days I'm amazed at the amount
you do remember ;-)

