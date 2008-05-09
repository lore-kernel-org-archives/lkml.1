Return-Path: <linux-kernel-owner+w=401wt.eu-S1765027AbYEIQvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765027AbYEIQvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbYEIQvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:51:04 -0400
Received: from server.drzeus.cx ([85.8.24.28]:38669 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755684AbYEIQvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:51:03 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 May 2008 12:51:02 EDT
Date: Fri, 9 May 2008 18:45:46 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "Justin Mattock" <justinmattock@gmail.com>
Cc: "Jiri Slaby" <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: post-2.6.25 locks up hard without any message
Message-ID: <20080509184546.34de6cdb@mjolnir.drzeus.cx>
In-Reply-To: <dd18b0c30804280956l1c5553c9qf8f9763d375f9a1c@mail.gmail.com>
References: <20080425175423.4bfd1c7b@mjolnir.drzeus.cx>
	<48125094.9070007@gmail.com>
	<dd18b0c30804251650me69a06fi573418ed48a3261d@mail.gmail.com>
	<20080428133523.34197aa3@mjolnir.drzeus.cx>
	<dd18b0c30804280956l1c5553c9qf8f9763d375f9a1c@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about the lack of updates, but I haven't had time to do any more
testing.

Anyhoo, I did an update today and the machine is running fine so far.
Looking at the git history, it seems the patch mentioned here was
included, which would explain things.

Thanks
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
