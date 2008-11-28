Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbYK1Nvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbYK1Nvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 08:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYK1Nvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 08:51:46 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47851 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750894AbYK1Nvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 08:51:45 -0500
Date: Fri, 28 Nov 2008 13:51:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: Izik Eidus <ieidus@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, avi@redhat.com,
       dlaor@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
       cl@linux-foundation.org, corbet@lwn.net
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux v2
Message-ID: <20081128135125.1ee31684@lxorguk.ukuu.org.uk>
In-Reply-To: <m33ahcc8kh.fsf@dmon-lap.sw.ru>
References: <1226888432-3662-1-git-send-email-ieidus@redhat.com>
	<m33ahcc8kh.fsf@dmon-lap.sw.ru>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You have implemented second one, but seems it already was patented
> http://www.google.com/patents?vid=USPAT6789156
> I'm not a lawyer but IMHO we have direct conflict here.
> >From other point of view they have patented the WEEL, but at least we
> have to know about this.

Its an old idea and appeared for Linux in March 1998: Little project from
Philipp Reisner called "mergemem".

http://groups.google.com/group/muc.lists.linux-kernel/browse_thread/thread/387af278089c7066?ie=utf-8&oe=utf-8&q=share+identical+pages#b3d4f68fb5dd4f88

so if there is a patent which is relevant (and thats a question for
lawyers and legal patent search people) perhaps the Linux Foundation and
some of the patent busters could take a look at mergemem and
re-examination.

Alan
