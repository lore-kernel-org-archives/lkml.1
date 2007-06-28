Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbXF1NZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbXF1NZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 09:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbXF1NZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 09:25:38 -0400
Received: from tartu.cyber.ee ([193.40.6.68]:4452 "EHLO tartu.cyber.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007AbXF1NZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 09:25:37 -0400
X-Greylist: delayed 1414 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jun 2007 09:25:37 EDT
From: Meelis Roos <mroos@linux.ee>
To: kloczek@rudy.mif.pg.gda.pl, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
In-Reply-To: <Pine.BSO.4.63.0706281351460.25800@rudy.mif.pg.gda.pl>
User-Agent: tin/1.9.2-20070201 ("Dalaruan") (UNIX) (Linux/2.6.22-rc6 (i686))
Message-Id: <20070628130213.EF4EE1414A@rhn.tartu-labor>
Date: Thu, 28 Jun 2007 16:02:13 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Our developers chose ALSA over OSS as the sound API for a VOIP-like
fullduplex application and one of the reasons was API - OSS mixer API
was not flexible enough (something to do with separating muting and
volume control IIRC).

-- 
Meelis Roos
