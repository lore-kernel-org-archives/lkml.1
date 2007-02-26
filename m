Return-Path: <linux-kernel-owner+w=401wt.eu-S1030295AbXBZPJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030295AbXBZPJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 10:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030294AbXBZPJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 10:09:53 -0500
Received: from smtp01.cdmon.com ([86.109.99.230]:54406 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbXBZPJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 10:09:52 -0500
X-Greylist: delayed 1408 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Feb 2007 10:09:52 EST
Date: Mon, 26 Feb 2007 15:47:44 +0100
From: DervishD <privado@dervishd.net>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: tdfx framebuffer garbles display in 2.6.19.5
Message-ID: <20070226144744.GA3615@DervishD>
Mail-Followup-To: Linux-kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi all :)

    From time to time, the tdfxfb driver from 2.6.19.5 (sorry, I cannot
test in 2.6.20.x because it doesn't compile, the infamous BDF negative
offset problem) garbles the display, leaving only a lot of thin lines,
just like sync was lost. The display can be repaired by switching to
another console, but this is annoying. This happens with a Voodoo 3
3000, using 800x600x8@100 mode.

    Anyone has this problem? Can it be solved changing anything?

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
