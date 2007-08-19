Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbXHSQmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbXHSQmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 12:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbXHSQmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 12:42:11 -0400
Received: from web38905.mail.mud.yahoo.com ([209.191.125.111]:26196 "HELO
	web38905.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753910AbXHSQmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 12:42:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=paMQJPXq6sTZ5d68sTeoh39hfvf/65dNkxkixtiGosvdHo3RNTt+AEUF2+8Dz1onuyX7BV5E6Vzcqmevo8Ax3FdbWvHhg6ds7vzuNHhWKmV3bmZ79VWkrUIR8lNbgHYEHc+TKKdMfTvl2EouEk8GKebUiId6ddIgUjRfdmNC23o=;
X-YMail-OSG: uH.B0uwVM1kWTHSKBeTdxhERJAdkPxiu4G0e00ze6Wwm0oxVOmwM3.R1ELnbjoj1oIgJCQQ9uX_qy9eg9n0e04JtZ1_V3BDuy.CwT9Bpvnbuo.POK6ximfbSfVX3kQ--
Date: Sun, 19 Aug 2007 09:42:08 -0700 (PDT)
From: Kevin E <kevin360@yahoo.com>
Subject: Re: Marvell 88E8056 gigabit ethernet controller
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20070819093221.4d3291e9@freepuppy.rosehill.hemminger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <623107.14278.qm@web38905.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Hemminger
<shemminger@linux-foundation.org> wrote:

> The working board has a different version of the
> Marvell chip:
> 
> $ grep Marvell working-MB 
> 04:00.0 Ethernet controller: Marvell Technology
> Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller
> (rev 14)
> $ grep Marvell broken-MB 
> 04:00.0 Ethernet controller: Marvell Technology
> Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller
> (rev 12)
> 
> Not sure if that completely explains the problem
> because the broken chip on my
> system is:
> 06:00.0 Ethernet controller: Marvell Technology
> Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller
> (rev 14)
> 
> I don't know what the differences are between
> versions.

Since I have a rev 14 that works and you have a rev 14
that doesn't work, is there any other info I can
provide to you that would maybe help in figuring out
how you can get your board working?



       
____________________________________________________________________________________
Looking for a deal? Find great prices on flights and hotels with Yahoo! FareChase.
http://farechase.yahoo.com/
