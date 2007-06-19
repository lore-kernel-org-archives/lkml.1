Return-Path: <linux-kernel-owner+w=401wt.eu-S1759134AbXFSQ6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbXFSQ6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 12:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbXFSQ63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 12:58:29 -0400
Received: from terminus.zytor.com ([192.83.249.54]:36214 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbXFSQ62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 12:58:28 -0400
Message-ID: <46780AD8.70304@zytor.com>
Date: Tue, 19 Jun 2007 09:56:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Allison <jra@samba.org>
CC: Theodore Tso <tytso@mit.edu>, alan <alan@clueserver.org>,
       Bodo Eggert <7eggert@gmx.de>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
References: <8wJal-3KA-1@gated-at.bofh.it> <8xm22-4Ql-1@gated-at.bofh.it> <8xq5G-32l-7@gated-at.bofh.it> <8xs7w-69W-21@gated-at.bofh.it> <E1I0OFQ-0001B9-7Z@be1.lrz> <Pine.LNX.4.64.0706181406250.25913@blackbox.fnordora.org> <4676F9A2.6010007@zytor.com> <20070618221021.GB2062@thunk.org> <20070618224815.GM1152@samba1> <20070619070507.GB9177@thunk.org> <20070619165224.GA19639@samba1>
In-Reply-To: <20070619165224.GA19639@samba1>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Allison wrote:
> 
> I'm not talking WinFS, I'm talking streams..... Streams are already
> being used (mainly by malware writers of course - but hey, don't
> you want full compatibility ? :-).
> 

Reminds me of the Linux Journal (I believe?) article which did
viruses-on-Wine compatibility testing.

	-hpa
