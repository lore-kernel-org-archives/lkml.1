Return-Path: <linux-kernel-owner+w=401wt.eu-S1751808AbYLHLKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbYLHLKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYLHLKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:10:24 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44014 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbYLHLKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:10:23 -0500
Message-ID: <493D008E.8050708@jp.fujitsu.com>
Date: Mon, 08 Dec 2008 20:10:06 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
CC: Andi Kleen <ak@linux.intel.com>, Arjan van de Ven <arjan@infradead.org>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>	 <493B4242.1040202@shaw.ca>	 <12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>	 <20081207141337.588aede5@infradead.org>	 <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>	 <493CCFE4.2080802@jp.fujitsu.com>	 <12bfabe40812080004p7438744eqeb884b42673bd73c@mail.gmail.com>	 <493CEAA0.50201@jp.fujitsu.com> <493CEF38.3060004@linux.intel.com>	 <493CF65B.30408@jp.fujitsu.com> <12bfabe40812080253k4154bc12he014496c027f4a85@mail.gmail.com>
In-Reply-To: <12bfabe40812080253k4154bc12he014496c027f4a85@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giangiacomo Mariotti wrote:
> As I said in a previous post, the boot option mce=nobootlog solved the
> problem at least from live-system point of view. About the problem at
> rebooting/halting time(reboot enters a cycle, halt gives an mce), do
> you have any suggestion? It seems like my bios is already the most
> recent version available(F3). My motherboard is a Gigabyte
> GA-EX58-UD5.

It would be better to create another thread by sending new mail with
proper subject, problem description and hardware configuration etc.

Vista can handle your system well, so something bad would be in Linux.
I guess some of ACPI folks will interested in the issue.

Thanks,
H.Seto

