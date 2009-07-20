Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbZGTTEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbZGTTEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZGTTEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:04:05 -0400
Received: from khc.piap.pl ([195.187.100.11]:50774 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZGTTEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:04:04 -0400
To: Thomas Hellstr?m <thomas@shipmail.org>
Cc: DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRM drivers with closed source user-space: WAS  [Patch 0/3] Resubmit VIA Chrome9 DRM via_chrome9 for upstream
References: <4A647358.1040009@shipmail.org>
	<20090720140956.GB11781@centrinvest.ru>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 20 Jul 2009 21:03:58 +0200
In-Reply-To: <20090720140956.GB11781@centrinvest.ru> (Andrey Panin's message of "Mon\, 20 Jul 2009 18\:09\:56 +0400")
Message-ID: <m33a8ruqg1.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Andrey Panin" <pazke@centrinvest.ru> writes:

>  * Users are still on mercy of binary blob supplier. Will this blob run on arm ?
> Or powerpc ? Or even x86_64 ? Will it be compatible with XOrg X.Y ?
> Nobody knows that and there is no gain for users too.

Actually there is a loss - users see the kernel (or partial) driver and
think it's open source solution. Been there, it wasn't nice at start
and even less nice when the thing chose not to work as advertised.

This was (is?) also the case with NVidia graphics drivers, I know many
people who purchased their cards thinking they are fully open-source
(because their drivers had to be "compiled").
-- 
Krzysztof Halasa
