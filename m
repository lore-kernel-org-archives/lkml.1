Return-Path: <linux-kernel-owner+w=401wt.eu-S1761748AbXHPP5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761748AbXHPP5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 11:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbXHPP50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 11:57:26 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:34493 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbXHPP5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 11:57:25 -0400
Message-ID: <46C472E1.6060703@gmail.com>
Date: Thu, 16 Aug 2007 17:53:05 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Kyle Moffett <mrmacman_g4@mac.com>, Satyam Sharma <satyam@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Joe Perches <joe@perches.com>, git@vger.kernel.org,
       Junio C Hamano <gitster@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
References: <1187110824.32555.76.camel@localhost> <46C1EE6F.2080807@gmail.com> <1187116082.32555.122.camel@localhost> <alpine.LFD.0.999.0708141131140.30176@woody.linux-foundation.org> <20070814193333.GI21089@ftp.linux.org.uk> <46C2548D.80605@gmail.com> <alpine.LFD.0.999.0708151846130.16414@enigma.security.iitk.ac.in> <46C30220.6060007@gmail.com> <68B09015-4411-470A-BA88-732969469AA2@mac.com> <46C42DCB.1060502@gmail.com> <20070816154029.GN21089@ftp.linux.org.uk>
In-Reply-To: <20070816154029.GN21089@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2007 05:40 PM, Al Viro wrote:

> On Thu, Aug 16, 2007 at 12:58:19PM +0200, Rene Herman wrote:

>> The git-blame thing as sketched before by Linus would never be able to 
>> point out mailing lists, or general lists of "interested parties" for 
>> example, but these properties can do anything...
> 
> No, they can not.  "I'm interested in drivers/foo/bar.c fixes" is not
> an earth-shattering event and it sure as hell does not create a new revision
> of the tree.

That's true. Okay, it can't do those general lists of interested parties.

Rene.

