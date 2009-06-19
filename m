Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZFSUt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZFSUt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 16:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbZFSUtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 16:49:51 -0400
Received: from torrent.cc.mcgill.ca ([132.206.27.49]:57707 "EHLO
	torrent.cc.mcgill.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbZFSUtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 16:49:50 -0400
Subject: Re: Panic booting 2.6.30
From: David Ronis <ronis@ronispc.chem.mcgill.ca>
Reply-To: ronis@ronispc.chem.mcgill.ca
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4A3BF591.3060500@msgid.tls.msk.ru>
References: <1245439404.25076.7.camel@ronispc.chem.mcgill.ca>
	 <4A3BE7EA.4050800@msgid.tls.msk.ru>
	 <1245442742.25076.9.camel@ronispc.chem.mcgill.ca>
	 <4A3BF591.3060500@msgid.tls.msk.ru>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Department of Chemistry, McGill University
Date: Fri, 19 Jun 2009 16:49:53 -0400
Message-Id: <1245444593.25076.16.camel@ronispc.chem.mcgill.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.3 
X-PMX-Version: 5.4.2.338381, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2009.6.15.190726
X-McGill-WhereFrom: Internal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2009-06-20 at 00:31 +0400, Michael Tokarev wrote:

> it and 2.6.30 is known to outgrow default lilo assumptions.  So it wasn't
> your case, it has to be in config change or in something failing during
> boot.

> And please don't top-post.
> 
> /mjt

I diffed the .config files for the 2 kernels.  The result is at

                       http://pastebin.ca/1466767

David
