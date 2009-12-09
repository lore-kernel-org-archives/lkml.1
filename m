Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbZLIPWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbZLIPWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbZLIPWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:22:05 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:52733 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbZLIPWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:22:04 -0500
X-Greylist: delayed 1527 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Dec 2009 10:22:04 EST
Date: Wed, 9 Dec 2009 15:55:55 +0100
From: Jan Yenya Kasprzak <kas@fi.muni.cz>
To: Rudy Matela <rudy.matela@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Coding style correction on some drivers that use Generic HDLC
Message-ID: <20091209145554.GQ6070@fi.muni.cz>
References: <20091209143540.GA9620@vacuum.larces.uece.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209143540.GA9620@vacuum.larces.uece.br>
User-Agent: Mutt/1.4.2.2i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 09 Dec 2009 15:55:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rudy Matela wrote:
: Added a space separating some if/switch/while keywords from the following
: parenthesis to conform to the CodingStyle.

	Hello,

	I am not sure whether it is necessary to fix formating mistakes in
a driver which is in deep freeze and the hardware is not produced anymore,
but whatever.

Acked-By: Jan "Yenya" Kasprzak <kas@fi.muni.cz>

-Yenya

: Signed-off-by: Rudy Matela <rudy.matela@gmail.com>
: ---
: 
:  drivers/net/wan/cosa.c       |   10 +++++-----
:  drivers/net/wan/hdlc_cisco.c |    8 ++++----
:  drivers/net/wan/hdlc_x25.c   |    4 ++--
:  3 files changed, 11 insertions(+), 11 deletions(-)
: 
: diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
: index b36bf96..f0bd70f 100644

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
Please don't top post and in particular don't attach entire digests to your
mail or we'll all soon be using bittorrent to read the list.     --Alan Cox
