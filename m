Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbZEGPvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbZEGPvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbZEGPv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:51:26 -0400
Received: from l2mail1.panix.com ([166.84.1.75]:49504 "EHLO l2mail1.panix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759075AbZEGPvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:51:25 -0400
X-Greylist: delayed 1360 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 May 2009 11:51:25 EDT
Date: Thu, 7 May 2009 09:28:41 -0600 (MDT)
From: Kenneth Crudup <kenny@panix.com>
cc: linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
In-Reply-To: <20090507120948.GA1531@ucw.cz>
Message-ID: <Pine.LNX.4.64.0905070925500.8967@hp9800.localdomain>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
 <20090507120948.GA1531@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 7 May 2009, Pavel Machek wrote:

> Given that distros ship uswsusp already... is that really an advantage.

Uswsusp has no compression. A suspend-to-disk that can take up to 5
minutes in uswsusp takes 20 seconds with TuxOnIce. Uswsusp has no built-
in hooks that allow me to run commands and set options during the suspend
and resume process.

	-Kenny

-- 
Kenneth R. Crudup  Sr. SW Engineer, Scott County Consulting, Los Angeles
O: 3630 S. Sepulveda Blvd. #138, L.A., CA 90034-6809      (888) 454-8181
