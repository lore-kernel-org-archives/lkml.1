Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbZL0AYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbZL0AYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 19:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbZL0AYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 19:24:43 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37767 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093AbZL0AYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 19:24:43 -0500
X-Sasl-enc: 7hAmJesZmHA9QJmsektHJwhSh7y7evtiSqDiJrBciCiG 1261873482
Date: Sat, 26 Dec 2009 22:24:39 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Myron Stowe <myron.stowe@hp.com>
Subject: Re: -tip: origin tree build failure
Message-ID: <20091227002439.GA26593@khazad-dum.debian.net>
References: <20091217075025.GA314@elte.hu>
 <alpine.LFD.2.00.0912261448100.4089@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912261448100.4089@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Dec 2009, Len Brown wrote:
> As my tree inflicted this one and I don't see your patch upstream,
> I'll include your fix with my "for -rc2" push.

I will be sending you an alternate patch in a few minutes, anyway.  If
you already sent the pull request, just let me know as that means I need
to adjust my tree.

Instead of depending on ALSA, I made the entire feature that depends on
ALSA optional.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
