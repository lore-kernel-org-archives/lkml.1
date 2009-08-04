Return-Path: <linux-kernel-owner+w=401wt.eu-S933084AbZHDRB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbZHDRB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 13:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932889AbZHDRB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 13:01:58 -0400
Received: from senator.holtmann.net ([87.106.208.187]:40827 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851AbZHDRB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 13:01:57 -0400
Subject: Re: [PATCH]bluetooth: rfcomm_init bug fix
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
Cc: hidave.darkstar@gmail.com, oliver@hartkopp.net, alan@lxorguk.ukuu.org.uk,
       netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090803.211136.00343745.davem@davemloft.net>
References: <20090803.132924.151782729.davem@davemloft.net>
	 <1249343666.3094.12.camel@localhost.localdomain>
	 <20090803.191916.75688176.davem@davemloft.net>
	 <20090803.211136.00343745.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 10:01:46 -0700
Message-Id: <1249405306.3094.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> >> do you mind at least waiting for an ACK from my side. I haven't even
> >> looked at the final patch.
> > 
> > Sure, I haven't pushed it out yet, so now's your chance :)
> 
> Grumble, I accidently pushed my net-2.6 queue out before you
> had a chance to reply, sorry :-(

not a big deal. Just have to send a cleanup patch. The patch itself is
fine, but from a style perspective it is different than everything else
in the Bluetooth subsystem and I would have liked to fix that before
pushing it. I wait with that for 2.6.32 since it is not important.

The other Dave, please send patches to linux-bluetooth only and lets
follow the normal path to get them merged into Linus' tree. Skipping
bluetooth-2.6 is not an option. You have to use the same process than
everybody else.

Regards

Marcel


