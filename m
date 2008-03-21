Return-Path: <linux-kernel-owner+w=401wt.eu-S1760231AbYCUSrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231AbYCUSrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbYCUSr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:47:27 -0400
Received: from japan.chezphil.org ([77.240.5.4]:5923 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbYCUSr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:47:27 -0400
X-Greylist: delayed 2918 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Mar 2008 14:47:27 EDT
To: <linux-kernel@vger.kernel.org>
Date: Fri, 21 Mar 2008 17:58:43 +0000
Subject: VIA Framebuffer - who's interested?
Message-ID: <1206122323597@dmwebmail.dmwebmail.chezphil.org>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
X-SPF-Guess: pass
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I am trying to track down people who are knowledgeable about 
framebuffer drivers for the VIA integrated graphics chips, as typically 
used on mini-ITX boards, especially the CN700.

As I understand it, VIA have provided source for kernel framebuffer 
drivers; these have not been suitable for mainline inclusion but it's a 
lot better than nothing.  Various other drivers have also appeared, in 
particular there is one in the DirectFB project's repo and there was 
one written by Dave Boucher and hosted at his website, 
davesdomain.org.uk.  I think that these were both based only on reading 
the VIA driver source; there's no other documentation.  I used Dave's 
driver very satisfactorily with a CLE266-based nano-ITX board.

The problem is that Dave's driver doesn't seem to work with my newer 
CN700-based board, and Dave and his website seem to have fallen off the 
net.  The official driver from VIA does work with this board, but it 
lacks some features that Dave's had.

So, I'm posting this in the hope that perhaps some reader has an idea 
what has happened to Dave Boucher and his driver, or can perhaps direct 
me to some other resources.

These mini-ITX boards are popular for things like MythTV - I use mine 
to drive a digital picture frame - but I worry that this is being done 
on a flimsy foundation.  As well as being unable to contact Dave, I 
have also had difficulty making contact with the people responsible for 
the X and DirectFB drivers for these chips.  Co-incidence, or 
consiparacy :-) ?

Thanks for any suggestions,

Phil.

(You're welcome to Cc: me in any replies.)



