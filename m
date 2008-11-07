Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbYKGLRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbYKGLRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 06:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYKGLRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 06:17:03 -0500
Received: from swm.pp.se ([212.247.200.143]:47208 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYKGLRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 06:17:01 -0500
Date: Fri, 7 Nov 2008 12:16:59 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: LKML <linux-kernel@vger.kernel.org>
cc: Netdev <netdev@vger.kernel.org>, linux-net@vger.kernel.org
Subject: Re: time for TCP ECN defaulting to on?
In-Reply-To: <8763mzx5l7.fsf@obelix.mork.no>
Message-ID: <alpine.DEB.1.10.0811071214320.10993@uplift.swm.pp.se>
References: <6278d2220811040632u7a36d68ekad5de517fd0671bb@mail.gmail.com> <alpine.DEB.1.10.0811052316210.10993@uplift.swm.pp.se> <20081105.151015.206163697.davem@davemloft.net> <alpine.DEB.1.10.0811070529550.10993@uplift.swm.pp.se>
 <Pine.LNX.4.64.0811070931190.23284@wrl-59.cs.helsinki.fi> <alpine.DEB.1.10.0811070854361.10993@uplift.swm.pp.se> <8763mzx5l7.fsf@obelix.mork.no>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1750580102-1226056619=:10993"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1750580102-1226056619=:10993
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 7 Nov 2008, Bjørn Mork wrote:

> I believe you can forget about ECN in core networks as long as these 
> searches fail:

A lot of ISPs use MPLS yes, but it would be a simplification to say that 
it's useless without MPLS support, because it's quite common that 
congestion happens at the interconnections/borders between ISPs and they 
are very rarely MPLS-labeled.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1750580102-1226056619=:10993--
