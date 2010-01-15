Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab0AOJW0 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 04:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774Ab0AOJWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 04:22:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48616
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578Ab0AOJWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 04:22:24 -0500
Date: Fri, 15 Jan 2010 01:22:33 -0800 (PST)
Message-Id: <20100115.012233.202457727.davem@davemloft.net>
To: stefanr@s5r6.in-berlin.de
Cc: adi@hexapodia.org, julia@diku.dk, nm127@freemail.hu, david.vrabel@csr.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, cocci@diku.dk
Subject: Re: Changelog quality
From: David Miller <davem@davemloft.net>
In-Reply-To: <tkrat.e88dd4dbf17f9bde@s5r6.in-berlin.de>
References: <4B502C6B.7000802@s5r6.in-berlin.de>
	<20100115.005445.263291449.davem@davemloft.net>
	<tkrat.e88dd4dbf17f9bde@s5r6.in-berlin.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Fri, 15 Jan 2010 10:17:08 +0100 (CET)

> I on the other hold the opinion that the changelog has one purpose, to
> describe the code change.

%99 of a bug fix is the process and means by which the bug was found,
therefore the "how was it found" is at least as important as how it is
fixed.

If the script in the commit bothers you, nobody forces you to read it
or use it.

If you want more clear markers around the script so you can skim
past it more efficiently when reading the commit message, then ask
for that.
