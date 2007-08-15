Return-Path: <linux-kernel-owner+w=401wt.eu-S1762682AbXHONod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762682AbXHONod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758332AbXHONnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 09:43:51 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:57749 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530AbXHONns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 09:43:48 -0400
Message-ID: <46C30220.6060007@gmail.com>
Date: Wed, 15 Aug 2007 15:39:44 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Joe Perches <joe@perches.com>, git@vger.kernel.org,
       Junio C Hamano <gitster@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
References: <1187026955.2688.4.camel@laptopd505.fenrus.org> <1187037445.6628.98.camel@heimdal.trondhjem.org> <1187054366.2757.0.camel@laptopd505.fenrus.org> <46C10AA8.3090505@gmail.com> <20070814102033.604c8695@the-village.bc.nu> <46C1CFFE.4000001@gmail.com> <1187110824.32555.76.camel@localhost> <46C1EE6F.2080807@gmail.com> <1187116082.32555.122.camel@localhost> <alpine.LFD.0.999.0708141131140.30176@woody.linux-foundation.org> <20070814193333.GI21089@ftp.linux.org.uk> <46C2548D.80605@gmail.com> <alpine.LFD.0.999.0708151846130.16414@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0708151846130.16414@enigma.security.iitk.ac.in>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2007 03:33 PM, Satyam Sharma wrote:

[ git info --maintainer ]

> I'd really _love_ a tool that does all that what you've proposed above!
> 
> But why does it have to be "git-info" or anything in the git(7) suite for
> that matter? This sounds like a job for a different specialised tool, 
> along with ".metatags" kind of files dispersed in the source tree.

To automatically move (and delete) the meta-data alongside the files 
themselves is a reason.

More generally -- shouldn't it? This is about source management (well, maybe 
more about project management, but...) and the source code management tool 
looks to be the right place for that. The different parts of git are 
somewhat/fairly stand-alone as is, no?

Rene.
