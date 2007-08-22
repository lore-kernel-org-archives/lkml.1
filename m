Return-Path: <linux-kernel-owner+w=401wt.eu-S932952AbXHVXcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbXHVXcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762384AbXHVXcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:32:01 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:19479 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760132AbXHVXcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:32:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=bsXtNdDzymS5wqqTX6H9hSmL1c4eH51WLxZvJlrZu3hrr3pWdiT9ZgEveQVKgLmp53VDdAu+HhNeCwZ40Dw1rGftW9mTPmwOi3NMR04X4AxpqQcksLwymrc1dtH/W2OWuGN1R+IWaLk1AujWcMbRNH/SXu9HuWqzzn6OpCcmz2k=
Message-ID: <46CCC716.1080708@googlemail.com>
Date: Thu, 23 Aug 2007 01:30:30 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Paul Hardwick <p.hardwick@option.com>
Subject: drivers/char/nozomi.c - compile error ( Re: 2.6.23-rc3-mm1 )
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


config : http://194.231.229.228/kernel/mm/2.6.23-rc3-mm1/r/randconfig-18

...

drivers/char/nozomi.c:2204: error: expected expression before '__attribute__'
make[2]: *** [drivers/char/nozomi.o] Error 1
make[1]: *** [drivers/char] Error 2
make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....


...
