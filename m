Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbXKDQzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbXKDQzR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 11:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbXKDQzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 11:55:05 -0500
Received: from khc.piap.pl ([195.187.100.11]:47943 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbXKDQzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 11:55:03 -0500
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>
	<4714EF01.2060609@s5r6.in-berlin.de>
	<m3d4vebylw.fsf@maximus.localdomain>
	<471527E5.1050407@s5r6.in-berlin.de>
	<m34pgpmszu.fsf@maximus.localdomain>
	<47166C83.2050207@s5r6.in-berlin.de>
	<m3fy09ffp9.fsf@maximus.localdomain>
	<4719A0C4.3050301@s5r6.in-berlin.de>
	<m3bqausztv.fsf@maximus.localdomain>
	<4719FF0F.3080504@s5r6.in-berlin.de>
	<m3ejfp4bg9.fsf@maximus.localdomain>
	<4724C9DA.7030900@s5r6.in-berlin.de>
	<m33avvdlbq.fsf@maximus.localdomain>
	<47251744.6090206@s5r6.in-berlin.de>
	<m3abq2ccb6.fsf@maximus.localdomain>
	<472CC8D9.8070609@s5r6.in-berlin.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 04 Nov 2007 17:54:59 +0100
In-Reply-To: <472CC8D9.8070609@s5r6.in-berlin.de> (Stefan Richter's message of "Sat, 03 Nov 2007 20:15:37 +0100")
Message-ID: <m3ejf63q8s.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

> For special occasions, Asustek hand out a testing and reprogramming
> utility from VIA to their customers (viafire.exe, together with EEPROM
> image files and instructions; see the link to the RAR archive at this
> page).  The documentation of the tool also contains a partial
> description of the EEPROM contents.

I see. I guess there is no much mystery in the EEPROM, i.e.
we know where to place GUID and PCI subsystem IDs and we know
how to initialize the rest (for both VT6306 and 6307, as it's
almost certainly the same). And we know how to handle VT6307
EEPROM programming.

I have no 6306 personally and I haven't connected a logic analyzer
to any so programming 6306 EEPROM is a speculation.

I will look at their archive "really soon" of course.
-- 
Krzysztof Halasa
