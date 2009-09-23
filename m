Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbZIWXXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbZIWXXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 19:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZIWXXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 19:23:39 -0400
Received: from sh.osrg.net ([192.16.179.4]:54268 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbZIWXXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 19:23:34 -0400
Date: Thu, 24 Sep 2009 08:21:51 +0900
To: kyle@moffetthome.net
Cc: hch@infradead.org, fujita.tomonori@lab.ntt.co.jp,
       lars.ellenberg@linbit.com, arjan@infradead.org, lmb@suse.de,
       jens.axboe@oracle.com, neilb@suse.de, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
       akpm@linux-foundation.org, bart.vanassche@gmail.com, davej@redhat.com,
       gregkh@suse.de, kosaki.motohiro@jp.fujitsu.com,
       torvalds@linux-foundation.org, nab@linux-iscsi.org, knikanth@suse.de,
       philipp.reisner@linbit.com, sam@ravnborg.org, Mauelshagen@redhat.com
Subject: Re: [GIT PULL] DRBD for 2.6.32
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <f73f7ab80909230701k438be273y1e363a9ef5579e4d@mail.gmail.com>
References: <f73f7ab80909211751p4d797556lcce5e47c3241b5ef@mail.gmail.com>
	<20090923115751.GA11820@infradead.org>
	<f73f7ab80909230701k438be273y1e363a9ef5579e4d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090924082042G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 24 Sep 2009 08:21:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 10:01:09 -0400
Kyle Moffett <kyle@moffetthome.net> wrote:

> The only thing missing is a list of exactly what still needs to be
> fixed.  I see a lot of handwaving about "We want a new API", but
> nobody defining what the requirements for that are.  If nobody can

Seems that you missed Christoph's requirements:

http://marc.info/?l=drbd-dev&m=125326222414549&w=2
