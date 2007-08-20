Return-Path: <linux-kernel-owner+w=401wt.eu-S932221AbXHTUmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbXHTUmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758113AbXHTUmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:42:38 -0400
Received: from postel.suug.ch ([194.88.212.233]:52483 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759534AbXHTUmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:42:37 -0400
X-Greylist: delayed 1489 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Aug 2007 16:42:37 EDT
Date: Mon, 20 Aug 2007 22:18:08 +0200
From: Thomas Graf <tgraf@suug.ch>
To: Felix Marti <felix@chelsio.com>
Cc: Andi Kleen <andi@firstfloor.org>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       jeff@garzik.org, netdev@vger.kernel.org, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org,
       David Miller <davem@davemloft.net>
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCPportsfrom the host TCP port space.
Message-ID: <20070820201808.GM32236@postel.suug.ch>
References: <p73y7g6yt3j.fsf@bingen.suse.de> <8A71B368A89016469F72CD08050AD334018E2149@maui.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A71B368A89016469F72CD08050AD334018E2149@maui.asicdesigners.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Felix Marti <felix@chelsio.com> 2007-08-20 12:02
> These graphic adapters provide a wealth of features that you can take
> advantage of to bring these amazing graphics to life. General purpose
> CPUs cannot keep up. Chelsio offload devices do the same thing in the
> realm of networking. - Will there be things you can't do, probably yes,
> but as I said, there are lots of knobs to turn (and the latest and
> greatest feature that gets hyped up might not always be the best thing
> since sliced bread anyway; what happened to BIC love? ;)

GPUs have almost no influence on system security, the network stack OTOH
is probably the most vulnerable part of an operating system. Even if all
vendors would implement all the features collected over the last years
properly which seems unlikely. Having such an essential and critical
part depend on the vendor of my network card without being able to even
verify it properly is truly frightening.
