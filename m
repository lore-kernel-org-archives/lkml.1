Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0BNVOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 16:14:19 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59249 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271Ab0BNVOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 16:14:17 -0500
X-Sasl-enc: aKzLncuWxfzyU5ML2woOSEOl3z4vzG/Y+9YNeVW0C9NQ 1266182056
Date: Sun, 14 Feb 2010 19:14:13 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Evans <mjevans1983@gmail.com>
Cc: Volker Armin Hemmann <volkerarmin@googlemail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
Message-ID: <20100214211413.GB15722@khazad-dum.debian.net>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
 <20100214193406.GA15722@khazad-dum.debian.net>
 <4877c76c1002141207s7bac4275xd12ed75e46a670c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4877c76c1002141207s7bac4275xd12ed75e46a670c4@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Feb 2010, Michael Evans wrote:
> Maybe you'd like a simple, easy to customize initramfs creator.

If the distro doesn't use it (as its default initramfs creator, even), it is
a lot more chance for breakage.  Less testing, and all that...

And if I am deploying a specific kernel in a server, you better believe it
is important enough that all due care will be taken so that it won't need an
initrd to mount the root filesystem to begin with ;-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
