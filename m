Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbXH1FlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbXH1FlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 01:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbXH1FlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 01:41:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:55170 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbXH1FlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 01:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Q56Nexz5VgdwuV9bNFWDSjw5bJFerv85TiG4TdNif009zw2PZF+O79FXkfbVzv4OjJ3OQlQ198lUg8GA8vHhq2XVGzU3Edk2CFSGMJR8jKR1Skp5aQYiSAWggJhEYSn2nrIslNYeqocU4n9yGKwnLh96wXaI6w3zY5tQNEVKi0g=
Message-ID: <46D3B572.2000201@gmail.com>
Date: Tue, 28 Aug 2007 07:41:06 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
References: <300725321593711206@pripojeni.net>	<20070827154049.8c5e61fe.akpm@linux-foundation.org>	<46D3B394.9090609@gmail.com> <20070827223638.0aa903ce.akpm@linux-foundation.org>
In-Reply-To: <20070827223638.0aa903ce.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Tue, 28 Aug 2007 07:33:08 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>>> Again, ARRAY_SIZE() would be clearer here.
>> No, this is only do this 16 times, no corresponding table :).
> 
> OK, poorly chosen example.  But there are lots of others, like:

Yes, you mentioned them further in the mail and I'm going to change those. I
only commented this one to let you know, that it's not about to change (if you
check it later).

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
