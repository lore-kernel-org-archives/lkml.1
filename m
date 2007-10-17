Return-Path: <linux-kernel-owner+w=401wt.eu-S936123AbXJQVGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936123AbXJQVGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 17:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760448AbXJQVGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 17:06:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37085 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758808AbXJQVGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 17:06:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47167952.8010903@s5r6.in-berlin.de>
Date: Wed, 17 Oct 2007 23:06:26 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux1394-user@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>	<4714EF01.2060609@s5r6.in-berlin.de>	<m3d4vebylw.fsf@maximus.localdomain>	<471527E5.1050407@s5r6.in-berlin.de>	<m34pgpmszu.fsf@maximus.localdomain>	<47166C83.2050207@s5r6.in-berlin.de> <m38x614g37.fsf@maximus.localdomain>
In-Reply-To: <m38x614g37.fsf@maximus.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Is the "dual buffer reception" involved in receiving video from
> a DV camera, using the new driver?

Yes, isochronous reception (and thus DV) with the new drivers currently
requires dual buffer mode.
-- 
Stefan Richter
-=====-=-=== =-=- =---=
http://arcgraph.de/sr/
