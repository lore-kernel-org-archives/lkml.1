Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbZFWWIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbZFWWIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbZFWWIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:08:36 -0400
Received: from mail.open.by ([193.232.92.17]:64893 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757388AbZFWWIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:08:36 -0400
X-Greylist: delayed 2594 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2009 18:08:35 EDT
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8817 [Jun 23 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Wed, 24 Jun 2009 01:10:07 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: kmemleak: Early log buffer exceeded
Message-ID: <20090623221007.GB9502@localdomain.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>2. When (crt_early_log >= ARRAY_SIZE(early_log)) == 1 we just can see stack.
>Since we have "full" early_log maybe it'll be helpfull to see it?

Sorry, sent you wrong message. Right one has no 'to see it' part.
I meant 'to do something more than just print stack'.

	Sergey
