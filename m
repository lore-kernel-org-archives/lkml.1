Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZICN7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZICN7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbZICN7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:59:17 -0400
Received: from khc.piap.pl ([195.187.100.11]:45135 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbZICN7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:59:16 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Lord <lkml@rtr.ca>,
       Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       NeilBrown <neilb@suse.de>, Rob Landley <rob@landley.net>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3: document conditions when reliable operation is possible)
References: <20090828064449.GA27528@elf.ucw.cz>
	<20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz>
	<alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm>
	<4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru>
	<20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com>
	<20090831131626.GA17325@infradead.org> <4A9BCDFE.50008@rtr.ca>
	<20090831132139.GA5425@infradead.org> <4A9F230F.40707@redhat.com>
	<m3ab1cp9ii.fsf@intrepid.localdomain> <4A9FA5F2.9090704@redhat.com>
	<m3ljkwnoct.fsf@intrepid.localdomain> <4A9FC9B3.1080809@redhat.com>
Date: Thu, 03 Sep 2009 15:59:13 +0200
In-Reply-To: <4A9FC9B3.1080809@redhat.com> (Ric Wheeler's message of "Thu, 03
	Sep 2009 09:50:43 -0400")
Message-ID: <m3ab1cnn7y.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler <rwheeler@redhat.com> writes:

> We (red hat) have all kinds of different raid boxes...

A have no doubt about it, but are those you know equipped with
battery-backed write-back cache? Are they using SATA disks?

We can _at_best_ compare non-battery-backed RAID using SATA disks with
what we typically have in a PC.
-- 
Krzysztof Halasa
