Return-Path: <linux-kernel-owner+w=401wt.eu-S933495AbXFRXBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495AbXFRXBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 19:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933057AbXFRXAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 19:00:14 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:33047 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933009AbXFRXAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 19:00:12 -0400
Date: Mon, 18 Jun 2007 16:00:11 -0700 (PDT)
From: alan <alan@clueserver.org>
X-X-Sender: alan@blackbox.fnordora.org
To: Jeremy Allison <jra@samba.org>
cc: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       Bodo Eggert <7eggert@gmx.de>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
In-Reply-To: <20070618224815.GM1152@samba1>
Message-ID: <Pine.LNX.4.64.0706181557000.25913@blackbox.fnordora.org>
References: <8wsCC-3wf-21@gated-at.bofh.it> <8wsW4-3UY-3@gated-at.bofh.it>
 <8wJal-3KA-1@gated-at.bofh.it> <8xm22-4Ql-1@gated-at.bofh.it>
 <8xq5G-32l-7@gated-at.bofh.it> <8xs7w-69W-21@gated-at.bofh.it>
 <E1I0OFQ-0001B9-7Z@be1.lrz> <Pine.LNX.4.64.0706181406250.25913@blackbox.fnordora.org>
 <4676F9A2.6010007@zytor.com> <20070618221021.GB2062@thunk.org>
 <20070618224815.GM1152@samba1>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Jeremy Allison wrote:

> Just because I now agree with you that streams are
> a bad idea doesn't mean the pressure to support them
> in some way in Samba has gone away :-).

Having dealt with Stream's support[1] in the past, I can assure you it is 
a bad idea.  ]:>

[1] http://www.stream.com/

-- 
"ANSI C says access to the padding fields of a struct is undefined.
ANSI C also says that struct assignment is a memcpy. Therefore struct
assignment in ANSI C is a violation of ANSI C..."
                                   - Alan Cox
