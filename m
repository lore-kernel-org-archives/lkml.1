Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab0AOIyi (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 03:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684Ab0AOIyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 03:54:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43482
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753722Ab0AOIyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 03:54:36 -0500
Date: Fri, 15 Jan 2010 00:54:45 -0800 (PST)
Message-Id: <20100115.005445.263291449.davem@davemloft.net>
To: stefanr@s5r6.in-berlin.de
Cc: adi@hexapodia.org, julia@diku.dk, nm127@freemail.hu, david.vrabel@csr.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, cocci@diku.dk
Subject: Re: Changelog quality
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B502C6B.7000802@s5r6.in-berlin.de>
References: <4B5023A6.5070100@s5r6.in-berlin.de>
	<20100115.002424.100105244.davem@davemloft.net>
	<4B502C6B.7000802@s5r6.in-berlin.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Fri, 15 Jan 2010 09:50:51 +0100

> David Miller wrote:
>> And likewise here, I want to see what the hell found the bug by
>> reading the changelog message.
> 
> Coccinelle found it.  In contrast to parsers like sparse, it had to be
> programmed to do so.  If you want to repeat that process, you have to
> get coccinelle and the script.  Both can be found quickly without having
> them both in the SCM.

I still don't see how this can argue for not putting the script into
the commit message.

And you overstate how "easily" the script can be found.

What button do I push in gitk when viewing a commit to find the
script?

If I have to go out of the tool, that's the beginning down the long
road of potential distractions.
