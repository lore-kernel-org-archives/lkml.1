Return-Path: <linux-kernel-owner+w=401wt.eu-S1763427AbYEFOn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763427AbYEFOn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 10:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbYEFOnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 10:43:17 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:57192 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753203AbYEFOnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 10:43:16 -0400
Message-ID: <48206ECF.9090005@seznam.cz>
Date: Tue, 06 May 2008 16:44:31 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: LTP for no MMU systems
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I tested Microblaze MMU kernel for finding where could be problem. I have no
problem with compilation. Microblaze MMU test result is on
http://www.monstr.eu/wiki/doku.php?id=kernel:testing.

I would like to test no MMU kernel too. Does anyone use it for no MMU kernel?
(Blackfin, m68k and others)

Thanks for info,
Michal

