Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbZGTWEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbZGTWEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 18:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZGTWEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 18:04:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753107AbZGTWEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 18:04:53 -0400
Date: Mon, 20 Jul 2009 15:04:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kiko Piris <kernel@pirispons.net>
cc: Damien Wyart <damien.wyart@free.fr>, Greg KH <gregkh@suse.de>,
       Wolfgang Walter <wolfgang.walter@stwm.de>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.30.2: does not boot
In-Reply-To: <alpine.LFD.2.01.0907201458000.19335@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0907201503200.19335@localhost.localdomain>
References: <20090720040813.GC11940@kroah.com> <200907201613.22483.wolfgang.walter@stwm.de> <20090720150916.GB10015@suse.de> <20090720180333.GA2905@brouette> <20090720192933.GA22641@superlopez.pirispons.net> <alpine.LFD.2.01.0907201241490.19335@localhost.localdomain>
 <20090720211908.GA31814@superlopez.pirispons.net> <alpine.LFD.2.01.0907201458000.19335@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Jul 2009, Linus Torvalds wrote:
> 
> Of course, maybe I missed some gcc flag confirmation that wasn't cc'd to 
> me. So who knows..

Never mind, There was the other thread about 2.6.27.7, and there it seems 
to have been confirmed. So yeah, we really do seem to have triggered two 
entirely separate bugs.

		Linus
