Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab0AOVmp (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758504Ab0AOVmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:42:44 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:19249 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483Ab0AOVmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:42:43 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 05/14] pci: add failed_list to record failed one for pci_bus_assign_resources
Date: Fri, 15 Jan 2010 14:41:59 -0700
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org> <1261522954-12591-6-git-send-email-yinghai@kernel.org>
In-Reply-To: <1261522954-12591-6-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001151442.00216.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 December 2009 04:02:25 pm Yinghai Lu wrote:
> so later we can do sth with those failed one

I feel like the grumpy old man yelling at the kids to stay off his lawn,
but I would like it a lot better if we avoided the IRC/texting shorthand
like "sth" in commit logs.  I can sort of deal with it in email, but the
commit logs are forever.  I *know* real English makes things easier for
me, and I suspect it makes an even bigger difference for non-native
speakers.

Bjorn
