Return-Path: <linux-kernel-owner+w=401wt.eu-S1751678AbZIENy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbZIENy0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 09:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbZIENyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 09:54:25 -0400
Received: from vena.lwn.net ([206.168.112.25]:48656 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbZIENyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 09:54:24 -0400
Date: Sat, 5 Sep 2009 07:54:24 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ric Wheeler <rwheeler@redhat.com>, Rob Landley <rob@landley.net>,
       jim owens <jowens@hp.com>, david@lang.hm, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
Message-ID: <20090905075424.4e103612@bike.lwn.net>
In-Reply-To: <20090905102810.GA1341@ucw.cz>
References: <20090826001645.GN4300@elf.ucw.cz>
	<200909022141.48827.rob@landley.net>
	<4A9FCF53.10105@hp.com>
	<200909040244.54772.rob@landley.net>
	<4AA0FECE.3010200@redhat.com>
	<20090905102810.GA1341@ucw.cz>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Sep 2009 12:28:10 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> >> The LWN article on the topic is out, and incomplete as it is I expect it's the
> >> best documentation anybody will actually _read_.  
> 
> Would anyone (probably privately?) share the lwn link?

	http://lwn.net/SubscriberLink/349970/9875eff987190551/

assuming you've not already gotten one from elsewhere.

jon
