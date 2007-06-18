Return-Path: <linux-kernel-owner+w=401wt.eu-S932869AbXFRUzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbXFRUzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765353AbXFRUzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:55:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61907 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765258AbXFRUzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:55:33 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Versioning file system
To: alan <alan@clueserver.org>, Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Reply-To: 7eggert@gmx.de
Date: Mon, 18 Jun 2007 22:54:52 +0200
References: <8wst3-3kh-31@gated-at.bofh.it> <8wsCC-3wf-21@gated-at.bofh.it> <8wsW4-3UY-3@gated-at.bofh.it> <8wJal-3KA-1@gated-at.bofh.it> <8xm22-4Ql-1@gated-at.bofh.it> <8xq5G-32l-7@gated-at.bofh.it> <8xs7w-69W-21@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1I0OFQ-0001B9-7Z@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+b27SKG8W7RPz4AkwdDjnyzwFL8PmROfPPGUf
 FzRGcfVRnwhuBukmuYQyXBiUrhV2Ty02yQWSXR7Y/tvosfrOt5
 oD5sqf5nfY5D0B7MvdA0A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

alan <alan@clueserver.org> wrote:

> I just wish that people would learn from the mistakes of others.  The
> MacOS is a prime example of why you do not want to use a forked
> filesystem, yet some people still seem to think it is a good idea.
> (Forked filesystems tend to be fragile and do not play well with
> non-forked filesystems.)

What's the conceptual difference between forks and extended user attributes?
-- 
"Unix policy is to not stop root from doing stupid things because
that would also stop him from doing clever things." - Andi Kleen

"It's such a fine line between stupid and clever" - Derek Smalls
