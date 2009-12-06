Return-Path: <linux-kernel-owner+w=401wt.eu-S934048AbZLFRqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048AbZLFRqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934021AbZLFRqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:46:11 -0500
Received: from mail.perches.com ([173.55.12.10]:1063 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934007AbZLFRqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:46:11 -0500
Subject: Re: [PATCH] scripts/checkpatch.pl: Add warning about leading
 contination tests
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Andy Whitcroft <apw@canonical.com>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       William Allen Simpson <william.allen.simpson@gmail.com>
In-Reply-To: <20091206131324.55436006@hyperion.delvare>
References: <1260035884.11126.58.camel@Joe-Laptop.home>
	 <4B1B6CB8.7000107@gmail.com>  <20091206131324.55436006@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Dec 2009 09:46:16 -0800
Message-ID: <1260121576.11126.83.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-06 at 13:13 +0100, Jean Delvare wrote:
> Not fine with me. Placing the binary logic operator at the beginning
> of a line can be a deliberate choice, either to make complex binary
> expressions more readable, or to avoid long lines. I don't see much
> point in banning this style, which BTW is used over 8000 times in the
> current kernel tree.

Anyone that thinks that checkpatch is the
last word on linux coding style and all of
its pronouncements must be followed all the
time is simply wrong.

It's not a ban.  It's neither a command nor
an edict.  It's a warning.  It's a notice
that leading logical continuations are not
the preferred style and it can be ignored
at will.

I think it's rather like the long line, >80
column warning.  There are a whole lot more
than 8k long lines in kernel source and no
one is suggesting reformatting all of them
out of existence.

cheers, Joe

