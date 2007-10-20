Return-Path: <linux-kernel-owner+w=401wt.eu-S1759851AbXJTNOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851AbXJTNOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 09:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbXJTNOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 09:14:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44759 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbXJTNOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 09:14:03 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4719FF0F.3080504@s5r6.in-berlin.de>
Date: Sat, 20 Oct 2007 15:13:51 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux1394-user@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>	<4714EF01.2060609@s5r6.in-berlin.de>	<m3d4vebylw.fsf@maximus.localdomain>	<471527E5.1050407@s5r6.in-berlin.de>	<m34pgpmszu.fsf@maximus.localdomain>	<47166C83.2050207@s5r6.in-berlin.de>	<m3fy09ffp9.fsf@maximus.localdomain>	<4719A0C4.3050301@s5r6.in-berlin.de> <m3bqausztv.fsf@maximus.localdomain>
In-Reply-To: <m3bqausztv.fsf@maximus.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> (the datasheet seems to suggest that)

Well, as mentioned, I don't put much trust into the datasheet.  It is
incomplete regarding the 1.0/1.1 issue.

> I wonder if OHCI 1.0 hardware based on VT6307 (and 6306) is
> a common thing, or is it just an exception.

Both chips are quite widespread.  From what I remember to have seen,
most VT6307 are programmed in OHCI 1.1 mode while all VT6306 seem to be
OHCI 1.0.
-- 
Stefan Richter
-=====-=-=== =-=- =-=--
http://arcgraph.de/sr/
