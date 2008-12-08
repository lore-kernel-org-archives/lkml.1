Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbYLHK50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbYLHK50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 05:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYLHK5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 05:57:17 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59982 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbYLHK5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 05:57:16 -0500
Message-ID: <493CFD7E.4060407@jp.fujitsu.com>
Date: Mon, 08 Dec 2008 19:57:02 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
CC: Arjan van de Ven <arjan@infradead.org>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>	 <493AF2EA.4030601@shaw.ca>	 <12bfabe40812061416u1b6f800dn7261beae5ce36b2f@mail.gmail.com>	 <493B4242.1040202@shaw.ca>	 <12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>	 <20081207141337.588aede5@infradead.org>	 <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>	 <493CCFE4.2080802@jp.fujitsu.com>	 <12bfabe40812080004p7438744eqeb884b42673bd73c@mail.gmail.com>	 <493CEAA0.50201@jp.fujitsu.com> <12bfabe40812080226h13b8d52bia39cc20b404ba910@mail.gmail.com>
In-Reply-To: <12bfabe40812080226h13b8d52bia39cc20b404ba910@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giangiacomo Mariotti wrote:
> I tried "mce=nobootlog" and the mce log seems to have disappeared :

Good.  It means the error was before the previous reset.

> Now that you mention it, I always shut down the system from Linux,
> because reboot doesn't work(from windows vista 32bit it works). If I
> reboot the system from Linux it goes down, but then it enters a cycle
> of automatic power down power up(with a beep) and it never stops until
> I switch off the power supply.

Wow... I suppose you had to report & solve it first.

Thanks,
H.Seto

