Return-Path: <linux-kernel-owner+w=401wt.eu-S1161335AbXBGO2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161335AbXBGO2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 09:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161336AbXBGO2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 09:28:48 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:60249 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161335AbXBGO2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 09:28:47 -0500
Date: Wed, 7 Feb 2007 15:28:07 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Oleg Verych <olecom@flower.upol.cz>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       William Stearns <wstearns@pobox.com>,
       Martin Schlemmer <azarah@nosferatu.za.org>
Subject: Re: [patch 1/3, resend] scripts: replace gawk, head, bc with shell,
 update
In-Reply-To: <20070206012207.805083000@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0702071527270.14457@scrub.home>
References: <20070206011819.160359000@flower.upol.cz> <20070206012207.805083000@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 6 Feb 2007, Oleg Verych wrote:

> scripts: replace gawk, head, bc with shell, update
> 
>   Replacing overhead of using some (external) programs
>   instead of good old `sh'.

awk is indeed a bit of overkill.

> 
> Cc: Roman Zippel <zippel@linux-m68k.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: William Stearns <wstearns@pobox.com>
> Cc: Martin Schlemmer <azarah@nosferatu.za.org>
> Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
> ---

Acked-by: Roman Zippel <zippel@linux-m68k.org>

bye, Roman
