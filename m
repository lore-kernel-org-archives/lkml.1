Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbYGQJss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbYGQJss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbYGQJsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:48:39 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50801 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbYGQJsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:48:39 -0400
Date: Thu, 17 Jul 2008 11:48:37 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: el es <el_es_cr@yahoo.co.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel version : what about s.yy.ww.tt scheme ?
In-Reply-To: <loom.20080717T083755-676@post.gmane.org>
Message-ID: <alpine.LNX.1.10.0807171140030.18697@fbirervta.pbzchgretzou.qr>
References: <loom.20080717T083755-676@post.gmane.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-07-17 10:51, el es wrote:

>Hello,
>inspired by the bikeshed painting contest, I got the following idea :
>
>The scheme to be s.yy.ww.tt, that is :
>
>s - series, as it is now (freedom to Linus to bump it to 3 when BKL is removed
>for example ;) )
>yy - two (in a hundred years, three) digits of the year
>Now the interesting part begins which is
>ww - the number of the week of the release. This will be between 1 and 52 (53)
>tt - the number of the week of stable release. As above.

Interesting idea.

>Take a hypotetical new-scheme 2.8.30 release (roughly the current
>2.6.26, didn't count these weeks). Linus starts to accumulate
>patches for 2.8.30-rcX as usual, and when he is ready to release,
>puts the release week number instead of 30 - let's assume it is a
>2.8.40 then, more or less. By the time, the stable team produces
>2.8.30.[32,34,36,38,40 and so on]. If the weeks leap into the next
>year, stable team puts e.g. 2.8.30.9.01 (yy.ww).

-stable usually overlaps with master. But I don't like version
numbers long as binutils and "2.8.30.9.01" have.

(BTW, IMHO it needs more than just a BKL removal to warrant a jump to 3.x)
