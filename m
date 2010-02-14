Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab0BNVeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 16:34:09 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51959 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753414Ab0BNVeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 16:34:04 -0500
X-Sasl-enc: 75UB8O8mtJs3aHJ/R+I/489S7fxoegVuIjHg4AioejAg 1266183243
Date: Sun, 14 Feb 2010 19:34:00 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Asdo <asdo@shiftmail.org>, Justin Piszcz <jpiszcz@lucidpixels.com>,
       Michael Evans <mjevans1983@gmail.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
Message-ID: <20100214213400.GD15722@khazad-dum.debian.net>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
 <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
 <4B77044B.1020609@zytor.com>
 <alpine.DEB.2.00.1002131507260.31103@p34.internal.lan>
 <4B7719C1.1060400@zytor.com>
 <4B785C49.7010105@shiftmail.org>
 <4B786898.8030309@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B786898.8030309@zytor.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Feb 2010, H. Peter Anvin wrote:
> IMO it would make sense to support autoassemble for 1.0 superblocks, and
> making them the default.  The purpose would be to get everyone off 0.9.
>  However, *any* default is better than 1.1.

Well, FWIW, I would happily use (and recommend) 1.0 with auto-assemble
(after verifying all the emergency repair toolset in use where I work has
been upgraded to support it) in distros where the bootloader has enough of a
clue to not bork on md-1.0 devices.  Which should be most of the current
crop.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
