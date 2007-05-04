Return-Path: <linux-kernel-owner+w=401wt.eu-S964784AbXEDHIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbXEDHIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964792AbXEDHIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:08:15 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2312 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784AbXEDHIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:08:14 -0400
From: "Miquel van Smoorenburg" <miquels@cistron.nl>
To: lorrides@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Routing 600+ vlan's via linux problems (looks like arp problems)
X-Newsgroups: lists.linux.kernel
In-Reply-To: <d20c3b7d0705032048l8c10d11i98a13881b1c8b3f3@mail.gmail.com>
References: <d20c3b7d0705031325r13834382r38ea31f26965c50@mail.gmail.com>
	 <20070503205341.GB943@1wt.eu>
	 <Pine.LNX.4.61.0705032255080.18504@yvahk01.tjqt.qr>
	 <d20c3b7d0705031412y11f18288t321c097aaad4b38b@mail.gmail.com>
	 <20070503222334.GD943@1wt.eu>
Organization: 
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1Hjrtj-0001pQ-Tl@n2o.xs4all.nl>
Date: Fri, 04 May 2007 09:08:11 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <d20c3b7d0705032048l8c10d11i98a13881b1c8b3f3@mail.gmail.com> you write:
>Its a Juniper M7i
>It comes default with a 5400 rpm laptop 2.5" harddrive but now we
>bought a more robust "server" 2.5" harddrive. It still barfs on the OS
>install, so the linux is doing all the job now. Will get a juniper guy
>to come and fix :)
>
>As a side note, i'm starting to wonder if it was worth the $20k when i
>could just have a linux machine to do the job with a clone for backup
>;)

Well, the features and esp. the JunOS cli are worth a lot. And
if you need to route more than say 3 gbit/s, PC hardware just
won't cut it.

Then again, if you like the CLI, don't need to route more
than 1 gbit/s, and don't need to do fancy stuff like MPLS,
QoS or shaping, there's always solutions like http://www.vyatta.com/

Mike.
