Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbXLTEST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbXLTEST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 23:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbXLTESK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 23:18:10 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36319 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544AbXLTESJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 23:18:09 -0500
X-Greylist: delayed 1597 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2007 23:18:09 EST
X-Sasl-enc: rUeujPFIKYT9a4JI3jkCWZpP/ck09qDwPbZID0kSxwAG 1198122691
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as
	well
From: Scott <linux-kernel@bluecamel.eml.cc>
To: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200712200313.54425.volker.armin.hemmann@tu-clausthal.de>
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de>
	 <Pine.LNX.4.64.0712171540040.6503@blonde.wat.veritas.com>
	 <200712172044.51629.volker.armin.hemmann@tu-clausthal.de>
	 <200712200313.54425.volker.armin.hemmann@tu-clausthal.de>
Content-Type: text/plain
Date: Wed, 19 Dec 2007 22:50:41 -0500
Message-Id: <1198122641.8341.1.camel@oasis.donpoo.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-20 at 03:13 +0100, Hemmann, Volker Armin wrote:
> On Montag, 17. Dezember 2007, you wrote:
> 
> and another one, this time tainted with the nvidia module:
> 5194.130985] Unable to handle kernel paging request at 0000030000000000 RIP:

This really sounds like bad hardware. Either memory or the mobo/riser
card the memory is on. You might try lowering the memory timings of your
memory in BIOS. Try removing 1/2 of your memory. If it still remove the
other 1/2 and put the first 1/2 back and try again.

-- 
Scott <linux-kernel@bluecamel.eml.cc>

