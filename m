Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbZIEV4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbZIEV4w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 17:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbZIEV4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 17:56:50 -0400
Received: from THUNK.ORG ([69.25.196.29]:51607 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbZIEV4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 17:56:49 -0400
Date: Sat, 5 Sep 2009 17:56:07 -0400
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jonathan Corbet <corbet@lwn.net>, Ric Wheeler <rwheeler@redhat.com>,
       Rob Landley <rob@landley.net>, jim owens <jowens@hp.com>, david@lang.hm,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Message-ID: <20090905215607.GA2287@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	Jonathan Corbet <corbet@lwn.net>, Ric Wheeler <rwheeler@redhat.com>,
	Rob Landley <rob@landley.net>, jim owens <jowens@hp.com>,
	david@lang.hm, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
References: <20090826001645.GN4300@elf.ucw.cz> <200909022141.48827.rob@landley.net> <4A9FCF53.10105@hp.com> <200909040244.54772.rob@landley.net> <4AA0FECE.3010200@redhat.com> <20090905102810.GA1341@ucw.cz> <20090905075424.4e103612@bike.lwn.net> <20090905212732.GB27650@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090905212732.GB27650@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 05, 2009 at 11:27:32PM +0200, Pavel Machek wrote:
> 
> Thanks, and thanks for nice article!

I agree; it's very nicely written, balanced, and doesn't scare users
unduly.

						- Ted
