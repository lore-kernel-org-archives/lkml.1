Return-Path: <linux-kernel-owner+w=401wt.eu-S932233AbXHTUiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbXHTUiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765472AbXHTUd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:33:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36251 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765461AbXHTUd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:33:57 -0400
Date: Mon, 20 Aug 2007 22:33:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Graf <tgraf@suug.ch>
Cc: Felix Marti <felix@chelsio.com>, Andi Kleen <andi@firstfloor.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, jeff@garzik.org,
       netdev@vger.kernel.org, rdreier@cisco.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org, David Miller <davem@davemloft.net>
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCPportsfrom the host TCP port space.
Message-ID: <20070820203355.GA21244@one.firstfloor.org>
References: <p73y7g6yt3j.fsf@bingen.suse.de> <8A71B368A89016469F72CD08050AD334018E2149@maui.asicdesigners.com> <20070820201808.GM32236@postel.suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070820201808.GM32236@postel.suug.ch>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> GPUs have almost no influence on system security, 

Unless you use direct rendering from user space.

-Andi
