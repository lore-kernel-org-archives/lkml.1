Return-Path: <linux-kernel-owner+w=401wt.eu-S1763020AbXHDULM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763020AbXHDULM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 16:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXHDULA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 16:11:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42533 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbXHDUK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 16:10:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46B4DBD1.9050206@s5r6.in-berlin.de>
Date: Sat, 04 Aug 2007 22:04:33 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Greg KH <gregkh@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       leoli@freescale.com, Gerrit Huizenga <gh@us.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, pavel@ucw.cz, tim.bird@am.sony.com,
       arjan@infradead.org, sam@ravnborg.org, jengelh@computergmbh.de,
       joe@perches.com, auke-jan.h.kok@intel.com, hansendc@us.ibm.com,
       davem@davemloft.net, Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       linux-doc@vger.kernel.org
Subject: Re: Documentation of kernel messages (Summary)
References: <E1I7wsz-0007oJ-DE@w-gerrit.beaverton.ibm.com> <200708031432.05714.rob@landley.net> <20070804035206.GB23330@suse.de> <200708041354.17653.rob@landley.net>
In-Reply-To: <200708041354.17653.rob@landley.net>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> Documentation is merely one resource among many, and 
> to link _out_ you need HTML.

Do you suggest HTML files in linux/Documentation?  I think we can follow
URIs and other references in plaintext files just fine.

(People who want clickable links in plaintext files can use plaintext
viewers which implement this, or utilities or browser plugins which
follow URLs in the clipboard.)
-- 
Stefan Richter
-=====-=-=== =--- --=--
http://arcgraph.de/sr/
