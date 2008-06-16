Return-Path: <linux-kernel-owner+w=401wt.eu-S1760545AbYFPHdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760545AbYFPHdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbYFPHdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:33:12 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:44366 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754673AbYFPHdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:33:11 -0400
Message-ID: <48561732.1040203@davidnewall.com>
Date: Mon, 16 Jun 2008 17:03:06 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: OBATA Noboru <noboru.obata.ar@hitachi.com>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-net@vger.kernel.org
Subject: Re: Feedback on TCP: Make TCP_RTO_MAX a variable
References: <4855823F.40208@davidnewall.com> <20080615195148.28c85c36@extreme>
In-Reply-To: <20080615195148.28c85c36@extreme>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> On Mon, 16 Jun 2008 06:27:35 +0930
> David Newall <davidn@davidnewall.com> wrote:
>   
>> ... caused by floods of packets directed towards the internet
>> link at one end or the other
> Why are you letting them through. Use proper firewalling.
>   

They didn't get through the router.  These floods congested the border
links (devices).

> A real VPN with IPSEC would have stopped the problem.
>   

No, it wouldn't.  If you don't see this, ask and I'll explain, again.


> I wouldn't put a mission critical system exposed directly to the Internet.
>   

I didn't.  Standard NAT appliances protect all ends.
