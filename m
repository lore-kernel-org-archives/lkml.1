Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbYATNIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbYATNIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 08:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbYATNIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 08:08:40 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50380 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752089AbYATNIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:08:39 -0500
Date: Sun, 20 Jan 2008 13:06:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080120130633.76c16d67@lxorguk.ukuu.org.uk>
In-Reply-To: <4792DD22.4070902@davidnewall.com>
References: <20080119045918.GA12215@basil.nowhere.org>
	<4792B191.2060801@davidnewall.com>
	<20080120031153.GB6275@one.firstfloor.org>
	<4792D221.1010704@davidnewall.com>
	<20080120051822.GB19784@one.firstfloor.org>
	<4792DD22.4070902@davidnewall.com>
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

> It's not necessarily that simple.  It might be for KFC and Dominoes, but
> for others, SCO is not the complete story.  Many legacy systems are
> written in COBOL, and must pay a per-seat licence for that on top of the
> per-seat licence for UNIX.  It is these systems that are most attracted
> towards SCO compatibility.

And they mostly use microfocus cobol which is available on Linux and uses
a vm is a trivial port, or they do a quick port to the fujitsu
cobol->java vm translator.

There are people in this community who deal day in and day out with
migrations. I don't hear a whisper of concern from those I deal with
about losing iBCS. 

Alan
