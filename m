Return-Path: <linux-kernel-owner+w=401wt.eu-S932406AbXC1WaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406AbXC1WaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 18:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933741AbXC1WaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 18:30:06 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43361 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932406AbXC1WaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 18:30:05 -0400
X-Greylist: delayed 834 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Mar 2007 18:30:04 EDT
X-Sasl-enc: 4S15P0HQA4+VBCCI9ZqYADooRWuUcCjcdzMeNfYdghic 1175121004
Message-ID: <460AECE6.8090703@imap.cc>
Date: Thu, 29 Mar 2007 00:32:06 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21-rc5
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070326221731.f4792260.akpm@linux-foundation.org>
In-Reply-To: <20070326221731.f4792260.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.03.2007 08:17 schrieb Andrew Morton:
> I have a few fixes here which belong to subsystem trees, which were missed
> by the maintainers and which we probably want to get into 2.6.21.
[...]
> Maintainers are cc'ed.  Please promptly ack, nack or otherwise quack, else
> I'll be making my own decisions ;)

[CC list trimmed]

It's not on that list, but would you mind slipping
drivers-isdn-gigaset-mark-some-static-data-as-const-v2.patch
into 2.6.21 too? It's largely trivial but I'd like to get it
out of the door.

Thanks,
Tilman

-- 
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeoeffnet mindestens haltbar bis: (siehe Rueckseite)
