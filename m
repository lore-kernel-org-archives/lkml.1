Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZITQfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZITQfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 12:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbZITQfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 12:35:03 -0400
Received: from fifo99.com ([67.223.236.141]:41202 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506AbZITQfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 12:35:02 -0400
Subject: Re: [PATCH][TRIVIAL] Fix comment in drivers/ata/pata_hpt37x.c.
From: Daniel Walker <dwalker@fifo99.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
In-Reply-To: <m3zl8p3dc4.fsf@intrepid.localdomain>
References: <m3zl8p3dc4.fsf@intrepid.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Sep 2009 09:35:00 -0700
Message-Id: <1253464500.10290.14.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-20 at 16:22 +0200, Krzysztof Halasa wrote:
> A comment fix in drivers/ata/pata_hpt37x.c.
> 
> Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>
> 

checkpatch has some trouble with your name ..

ERROR: Invalid UTF-8, patch and commit message should be encoded in UTF-8
#42: 
Signed-off-by: Krzysztof Haasa <khc@pm.waw.pl>
                           ^

I've seen this warning a few times, and I wasn't sure to exactly what to
do with it.. However, it does seem like a lot of people have trouble
with the encodings ..

I did a little research and I think I was able to produce your name in
utf8 (checkpatch doesn't error any longer..)

Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>

Are you aware that your name isn't in utf8? Does the above name look
right to you? To me my version looks identical to your version ..

Daniel

