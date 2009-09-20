Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbZITRDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbZITRDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 13:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbZITRDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 13:03:49 -0400
Received: from khc.piap.pl ([195.187.100.11]:58896 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbZITRDs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 13:03:48 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH][TRIVIAL] Fix comment in drivers/ata/pata_hpt37x.c.
References: <m3zl8p3dc4.fsf@intrepid.localdomain>
	<1253464500.10290.14.camel@desktop>
Date: Sun, 20 Sep 2009 19:03:50 +0200
In-Reply-To: <1253464500.10290.14.camel@desktop> (Daniel Walker's message of
	"Sun, 20 Sep 2009 09:35:00 -0700")
Message-ID: <m3zl8psg3t.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker <dwalker@fifo99.com> writes:

> I did a little research and I think I was able to produce your name in
> utf8 (checkpatch doesn't error any longer..)
>
> Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>
>
> Are you aware that your name isn't in utf8? Does the above name look
> right to you? To me my version looks identical to your version ..

Well, it looks like at some point I instructed my Gnus to send in ISO
8859-* encoding if possible. Probably you used the raw "mail spool"
file, instead of converting to UTF-8. Not much surprise, though. There
is no reason for me to use 8859 encodings anymore, I've just switched
that to UTF-8.

Thanks for noticing.
-- 
Krzysztof Hałasa
