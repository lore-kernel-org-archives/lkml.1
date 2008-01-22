Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbYAVQxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbYAVQxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 11:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYAVQwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 11:52:46 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36944 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752672AbYAVQwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 11:52:45 -0500
Date: Tue, 22 Jan 2008 16:50:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080122165015.5aca62ac@lxorguk.ukuu.org.uk>
In-Reply-To: <4796081A.7060505@davidnewall.com>
References: <20080119045918.GA12215@basil.nowhere.org>
	<4792B191.2060801@davidnewall.com>
	<20080120031153.GB6275@one.firstfloor.org>
	<4792D221.1010704@davidnewall.com>
	<20080120051822.GB19784@one.firstfloor.org>
	<4792DD22.4070902@davidnewall.com>
	<20080120055544.GB19861@one.firstfloor.org>
	<4792E8E2.1090307@davidnewall.com>
	<20080120072922.GA21047@one.firstfloor.org>
	<4793F775.6090403@davidnewall.com>
	<20080122111205.GA25090@elte.hu>
	<4796081A.7060505@davidnewall.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> You're being silly.  Either that or you're not reading what I write. 
> You know perfectly well iBCS2 compatibility doesn't work (anymore.)  The
> question, in my mind, is will it ever be made to work again?  I think
> the answer should be yes.

We await your patches. If you think it should be done then rework the
code, test it and figure how to merge it nicely.

Alan
