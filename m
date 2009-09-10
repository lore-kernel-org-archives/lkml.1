Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbZIJUWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbZIJUWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZIJUWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:22:10 -0400
Received: from baron.coraid.com ([12.51.113.4]:64165 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752950AbZIJUWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:22:10 -0400
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Thu, 10 Sep 2009 16:20:34 -0400
To: jens.axboe@oracle.com, ecashin@coraid.com, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, apw@canonical.com, bonbons@linux-vserver.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aoe: end barrier bios with EOPNOTSUPP
Message-ID: <178912f8877bbbbbd5aa5cd4a082f8a9@coraid.com>
In-Reply-To: <20090910200735.GX18599@kernel.dk>
References: <20090908193540.GB18599@kernel.dk>
	<60772f633c524ba873f569966fccd6ce@coraid.com>
	<20090909180804.3e62331a@lxorguk.ukuu.org.uk>
	<30b7855d211ab5b6bef6fe2cd9b76295@coraid.com>
	<20090909205835.GK18599@kernel.dk>
	<810bbe1723b0a205f9b5018a5ddaa722@coraid.com>
	<20090910074820.GS18599@kernel.dk>
	<84f18127dcdb4762bf9dc6796846087f@coraid.com>
	<20090910195021.GW18599@kernel.dk>
	<aa669085856b88bee82d150efe84b682@coraid.com>
	<20090910200735.GX18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Sep 10 16:07:37 EDT 2009, jens.axboe@oracle.com wrote:
> On Thu, Sep 10 2009, Ed Cashin wrote:
...
> > So, yes, if you don't mind pushing the patch to the appropriate place,
> > that would be great.
> 
> Did you repost a non-whitespace damaged version?

Yes.  I'll post it again as a response to this email.

> > Now I have to figure out why the other patch in aoe's quilt tree for
> > linux-next never made it to 2.6.31.
> 
> Things don't go from -next to mainstream automatically, -next is just a
> testing base. You have to submit it explicitly, eg send it to me.

Ah.  Thanks.

-- 
  Ed
