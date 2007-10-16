Return-Path: <linux-kernel-owner+w=401wt.eu-S935899AbXJPVHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935899AbXJPVHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935005AbXJPVG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:06:59 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41720 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934153AbXJPVG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:06:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <471527E5.1050407@s5r6.in-berlin.de>
Date: Tue, 16 Oct 2007 23:06:45 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux1394-user@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>	<4714EF01.2060609@s5r6.in-berlin.de> <m3d4vebylw.fsf@maximus.localdomain>
In-Reply-To: <m3d4vebylw.fsf@maximus.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Both VT6306 and VT6307 datasheets claim selectable OHCI 1.0/1.1.
> I guess they did that for compatibility or something like that.

I wouldn't read too much into these data sheets.  Note that actual OHCI
1.1 features are nowhere documented in these data sheets; i.e. this
documentation can't be trusted to begin with.

As far as VT6306 is concerned, the wording could be copy'n'waste from
the VT6307 datasheet.  And in case of VT6307, I suspect it's VIA who
selects the implementation level (based on chip revision), not the card
vendor.
-- 
Stefan Richter
-=====-=-=== =-=- =----
http://arcgraph.de/sr/
