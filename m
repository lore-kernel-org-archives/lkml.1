Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbXEETz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbXEETz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 15:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933219AbXEETz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 15:55:57 -0400
Received: from v05705.home.net.pl ([212.85.118.117]:65323 "HELO
	v05705.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754238AbXEETz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 15:55:56 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 May 2007 15:55:55 EDT
Date: Sat, 5 May 2007 21:49:22 +0200
From: Zbigniew Baniewski <zb@ispid.com.pl>
To: linux-kernel@vger.kernel.org
Subject: "modularized" 2.4.34.4  ->  ide-core "unresolved symbols"
Message-ID: <20070505194922.GA13176@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo,

I was trying to make "modularized kernel" (s.c. "Debian way") recently, yes,
I made even kernel.deb package - but at the installation, I'm still getting
an error: "ide-core: unresolved symbols".

Making a quick search with Google I could see, it did occur to many other
people even long ago. There was even a patch introduced - which, I believe,
is in the 2.4.34.4 "drivers/ide" sub-dir - unfortunately it seems, that the
patch is working no more.

Perhaps there is another patch available for 2.4.34.4 ?
-- 
				pozdrawiam / regards

						Zbigniew Baniewski
