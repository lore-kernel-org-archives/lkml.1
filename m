Return-Path: <linux-kernel-owner+w=401wt.eu-S1762636AbXEVUkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762636AbXEVUkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757884AbXEVUjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:39:53 -0400
Received: from khc.piap.pl ([195.187.100.11]:38585 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431AbXEVUjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:39:51 -0400
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
	<20070522135927.GA2098@stusta.de>
	<Pine.LNX.4.64.0705221002350.14457@localhost.localdomain>
	<20070522161951.GC2098@stusta.de> <m3ejl8k6e3.fsf@maximus.localdomain>
	<Pine.LNX.4.64.0705221616270.18792@localhost.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 22 May 2007 22:39:50 +0200
In-Reply-To: <Pine.LNX.4.64.0705221616270.18792@localhost.localdomain> (Robert P. J. Day's message of "Tue, 22 May 2007 16:17:48 -0400 (EDT)")
Message-ID: <m37ir0iodl.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Robert P. J. Day" <rpjday@mindspring.com> writes:

> that may be but, as i suggested earlier, that would get into guessing
> what those developers were thinking, and i just didn't want to go
> there.

No guessing, I just checked it (though a second check wouldn't do
any harm).

> the simple version of the patch is now in andrew's tree, and i'll
> worry about the harder stuff next time.

The "next time" would be much harder as there would be no key for
searching for these functions.
-- 
Krzysztof Halasa
