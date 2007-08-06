Return-Path: <linux-kernel-owner+w=401wt.eu-S934088AbXHFPgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088AbXHFPgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934018AbXHFPgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:36:13 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:48227
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933431AbXHFPgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:36:10 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Documentation of kernel messages (Summary)
Date: Mon, 6 Aug 2007 11:50:51 -0400
User-Agent: KMail/1.9.6
Cc: Greg KH <gregkh@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
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
References: <E1I7wsz-0007oJ-DE@w-gerrit.beaverton.ibm.com> <200708041354.17653.rob@landley.net> <46B4DBD1.9050206@s5r6.in-berlin.de>
In-Reply-To: <46B4DBD1.9050206@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708061050.53263.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 August 2007 3:04:33 pm Stefan Richter wrote:
> Rob Landley wrote:
> > Documentation is merely one resource among many, and
> > to link _out_ you need HTML.
>
> Do you suggest HTML files in linux/Documentation?

I've thought about it, but right now Documentation is text.  Converting all 
the existing text files to html is a fairly intrusive change, and having 
multiple file formats in there seems even more untidy.  (What next, pdf?).

I'm aware there are some docbook files in there, plus an ancient graphic file, 
plus the bloody stains of various chicken sacrificies, but the point would be 
how best to clean it up...

> I think we can follow 
> URIs and other references in plaintext files just fine.

Go for it.  Have fun.  I'll be over here.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
