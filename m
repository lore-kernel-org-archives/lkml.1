Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbXLDWkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbXLDWkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbXLDWkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:40:37 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34896 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbXLDWkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:40:36 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4755D757.7060002@s5r6.in-berlin.de>
Date: Tue, 04 Dec 2007 23:40:23 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.9) Gecko/20071122 SeaMonkey/1.1.6
MIME-Version: 1.0
To: Bernhard Kaindl <bkaindl@ffii.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Andi Kleen <ak@suse.de>,
       Bernhard Kaindl <bk@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: remote debugging via FireWire * __fast__ firedump!
References: <200702101242.48467.ak@suse.de> <45CDCDCD.5000609@s5r6.in-berlin.de> <alpine.DEB.0.9999.0712040426100.3769@vic.ffii.org> <4755D186.20204@s5r6.in-berlin.de> <4755D612.1090103@s5r6.in-berlin.de>
In-Reply-To: <4755D612.1090103@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PPS:  Today I had a brief look through your current sources.  Look good
so far, except for a curious hunk which patches drivers/Makefile.  And I
can't say anything to the x86 platform related and PCI related aspects
of the driver.
-- 
Stefan Richter
-=====-=-=== ==-- --=--
http://arcgraph.de/sr/
