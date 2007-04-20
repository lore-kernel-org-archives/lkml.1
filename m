Return-Path: <linux-kernel-owner+w=401wt.eu-S2992448AbXDTIDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992448AbXDTIDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992464AbXDTIDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:03:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992448AbXDTIDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:03:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070419.131448.71554303.davem@davemloft.net> 
References: <20070419.131448.71554303.davem@davemloft.net>  <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <29341.1176975158@redhat.com> <2969.1176992303@redhat.com> 
To: David Miller <davem@davemloft.net>
Cc: ebiederm@xmission.com, akpm@osdl.org, containers@lists.osdl.org,
       oleg@tv-sign.ru, hch@infradead.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Getting the new RxRPC patches upstream 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 20 Apr 2007 09:02:07 +0100
Message-ID: <1101.1177056127@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

> I applied already the patches I thought were appropriate,
> you had some crypto layer changes that you need to work
> out with Herbert Xu before the rest can be applied.

Should the rest of it go via Andrew's tree then?

David
