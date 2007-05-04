Return-Path: <linux-kernel-owner+w=401wt.eu-S1767596AbXEDHbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767596AbXEDHbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767598AbXEDHbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:31:13 -0400
Received: from ns.suse.de ([195.135.220.2]:39482 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767596AbXEDHbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:31:12 -0400
To: "Miquel van Smoorenburg" <miquels@cistron.nl>
Cc: lorrides@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Routing 600+ vlan's via linux problems (looks like arp problems)
References: <d20c3b7d0705031325r13834382r38ea31f26965c50@mail.gmail.com>
	<20070503205341.GB943@1wt.eu>
	<Pine.LNX.4.61.0705032255080.18504@yvahk01.tjqt.qr>
	<d20c3b7d0705031412y11f18288t321c097aaad4b38b@mail.gmail.com>
	<20070503222334.GD943@1wt.eu> <E1Hjrtj-0001pQ-Tl@n2o.xs4all.nl>
From: Andi Kleen <andi@firstfloor.org>
Date: 04 May 2007 10:28:41 +0200
In-Reply-To: <E1Hjrtj-0001pQ-Tl@n2o.xs4all.nl>
Message-ID: <p73lkg5vvpi.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Miquel van Smoorenburg" <miquels@cistron.nl> writes:

> And
> if you need to route more than say 3 gbit/s, PC hardware just
> won't cut it.

Each new x86 hardware generation normally can route more than the previous
generation. If you give out such a dubious number you would always need to give
it a (short) expiry date.

-Andi
