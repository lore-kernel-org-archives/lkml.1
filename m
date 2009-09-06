Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbZIFSkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbZIFSkq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 14:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757970AbZIFSko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 14:40:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48473 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbZIFSko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 14:40:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: 2.6.31.rc9
Date: Sun, 6 Sep 2009 20:41:19 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200909061402.21536.gene.heskett@verizon.net>
In-Reply-To: <200909061402.21536.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909062041.19361.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 September 2009, Gene Heskett wrote:
> Greetings all;
> 
> I went ahead and buiilt 2.6.31-rc9 & rebooted to it, but I am being plagued 
> by segfaults, taking down knotify and kmail, and a bluetooth tool I just 
> tried to run.
> 
> kmail restarted ok, but several others have reported that the exec call 
> failed.
> 
> No more than I know about slabtop, it looks much like it has before.

Is that 64-bit or 32-bit?

I don't see the problems you describe on any of my test boxes.

Rafael
