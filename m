Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbZKQWSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbZKQWSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbZKQWSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:18:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950AbZKQWSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:18:20 -0500
Date: Tue, 17 Nov 2009 23:18:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?ISO-8859-15?Q?=22Andr=E9_Goddard_Rosa=22?= 
	<andre.goddard@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: manual merge of the trivial tree with the wireless
 tree
In-Reply-To: <20091117154957.a23c959b.sfr@canb.auug.org.au>
Message-ID: <alpine.LSU.2.00.0911172317560.15039@wotan.suse.de>
References: <20091117154957.a23c959b.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009, Stephen Rothwell wrote:

> Today's linux-next merge of the trivial tree got a conflict in
> drivers/net/wireless/rt2x00/rt2800usb.h between various commits from the
> wireless tree and commit 17530b1c635dfd1f258afc6b07b986b425d66ebd
> ("tree-wide: fix assorted typos all over the place") from the trivial
> tree.
> 
> The wireless tree commits moved the code fixed by the trivial tree, but
> also fixed it along the way, so I have ignored the trivial fixup for this
> file.

Thanks for letting me know, I have dropped the rt2800usb bits from my 
queue, so this conflict should now be gone.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
