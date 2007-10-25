Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbXJYTKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbXJYTKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbXJYTK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:10:28 -0400
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:56909 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754140AbXJYTKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:10:05 -0400
X-Greylist: delayed 1680 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 15:10:04 EDT
From: Daniel Exner <dex@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: linux-kernel@vger.kernel.org
Subject: Uvesafb and token-ring in 2.6.24-rc1 broken
Date: Thu, 25 Oct 2007 20:37:09 +0200
User-Agent: KMail/1.9.7
Cc: Jeff Garzik <jeff@garzik.org>, Michal Januszewski <spock@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710252037.09667.dex@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;dex@dragonslave.de;1193339404;519d583a;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Like always, pleas CC me as I'm currently not suscribed, I hope I got the 
right persons already in list.

When booting my new shiny 2.6.24-rc1 I get a crash if uvesafb is compiled in. 
The trace mentiones something about "platform_match", so I guess this is due 
x86 unification.
If helpfull I could try getting something over netconsole, but I think this is 
a minor glitch, as vesafb boots fine. :)

Ah, and token ring tells me something like
"/net/token-ring ,3.14 sysctl failed check procname does not match binary path 
procname"
But kernel boots otherwise and I got no chance to test tr itself is working.

-- 
Greetings
Daniel Exner
