Return-Path: <linux-kernel-owner+w=401wt.eu-S1761952AbXIJWXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952AbXIJWXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 18:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761123AbXIJWXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 18:23:15 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:37664 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759089AbXIJWXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 18:23:15 -0400
Message-ID: <46E5C21C.8040609@gmail.com>
Date: Tue, 11 Sep 2007 00:15:56 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, perex@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
References: <20070909202527.GT3563@stusta.de> <20070909203920.GA11764@infradead.org> <20070909145940.0b41c8a5.akpm@linux-foundation.org> <20070910090808.GA31204@infradead.org> <20070910022324.c69e1897.akpm@linux-foundation.org> <20070910124358.GB21089@ftp.linux.org.uk> <20070910102556.de35e825.akpm@linux-foundation.org> <20070910195821.GH3563@stusta.de> <20070910131759.a7b2dce7.akpm@linux-foundation.org> <20070910221848.GJ3563@stusta.de>
In-Reply-To: <20070910221848.GJ3563@stusta.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2007 12:18 AM, Adrian Bunk wrote:

> On Mon, Sep 10, 2007 at 01:17:59PM -0700, Andrew Morton wrote:

>> There is no benefit in making some rigid set of rules.
> 
> Is is considered beneficial to provide API stability for external 
> modules or not?

If I may...

Yes, it is. Just not at any significant cost and Andrew is saying that he 
considers the _UNUSED() thing not significant.

Rene.
