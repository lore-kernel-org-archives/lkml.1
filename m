Return-Path: <linux-kernel-owner+w=401wt.eu-S1765828AbXHHMQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765828AbXHHMQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 08:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759698AbXHHMQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 08:16:28 -0400
Received: from mx2.go2.pl ([193.17.41.42]:48440 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765381AbXHHMQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 08:16:26 -0400
Date: Wed, 8 Aug 2007 14:16:58 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Jean-Baptiste Vignaud <vignaud@xandmail.fr>
Cc: cebbert <cebbert@redhat.com>, mingo <mingo@elte.hu>,
       "marcin\.slusarz" <marcin.slusarz@gmail.com>, tglx <tglx@linutronix.de>,
       torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070808121658.GA4110@ff.dom.local>
References: <JMG6AY$2339D4FEA804188F4C6D4F66006A6BB6@xandmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <JMG6AY$2339D4FEA804188F4C6D4F66006A6BB6@xandmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 10:59:22AM +0200, Jean-Baptiste Vignaud wrote:
...
> > If you would like to read something more about testing (then of
> > course my suggestions could occur invalid - I'm a very bad tester
> > myself...) you can try this:
> > http://www.stardust.webpages.pl/files/handbook/
> 
> I'll have a look at the document.

BTW: this document describes some methods for a kind of 'professional'
testing (so you could save time if you do it very often). But, you
shouldn't think all this knowledge or tools are necessary. So, you can
skip many such things and still do very valuable testing with simpler
methods. And there are a lot of simple & good advices as well.

BTW #2: this all testing of older versions, which I've described, has
of course any reason only if after present patches you'll still think
the older kernel had worked better for you.

Jarek P. 
