Return-Path: <linux-kernel-owner+w=401wt.eu-S1752137AbZH1Hmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbZH1Hmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 03:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZH1Hmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 03:42:33 -0400
Received: from emita2.mittwald.de ([85.199.173.189]:38125 "EHLO
	emita2.mittwald.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZH1Hmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 03:42:32 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Aug 2009 03:42:32 EDT
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: ar9271 mailing list and driver project page
Date: Fri, 28 Aug 2009 09:34:53 +0200
User-Agent: KMail/1.9.7
Cc: devel@driverdev.osuosl.org,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
References: <43e72e890908271943s6dca1257g1f1e56d0347cc21d@mail.gmail.com>
In-Reply-To: <43e72e890908271943s6dca1257g1f1e56d0347cc21d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908280934.53681.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ar9271 and ar9170 seem to share a few things, one of which is
> firmware upload. ar9271's firmware upload routine was modified
> to make it match ar9170's as much as possible to share it on
> ath.ko

Is it true that most devices which will use ath.ko won't ever use 
firmware uploading?  It's only a few Ath-USB devices, so maybe 
you could do an ath_fw.ko for this.

(Somebody who's always working with embedded devices and likes to 
keeps small :-)

-- 
http://www.holgerschurig.de
