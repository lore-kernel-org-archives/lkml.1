Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbZKDNaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbZKDNaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbZKDNaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:30:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34545
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755340AbZKDNaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:30:04 -0500
Date: Wed, 04 Nov 2009 05:30:29 -0800 (PST)
Message-Id: <20091104.053029.166783766.davem@davemloft.net>
To: mst@redhat.com
Cc: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com, rusty@rustcorp.com.au, s.hetze@linux-ag.com
Subject: Re: [PATCHv7 1/3] tun: export underlying socket
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091103172400.GB5591@redhat.com>
References: <cover.1257267892.git.mst@redhat.com>
	<20091103172400.GB5591@redhat.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Tue, 3 Nov 2009 19:24:00 +0200

> Assuming it's okay with davem, I think it makes sense to merge this
> patch through Rusty's tree because vhost is the first user of the new
> interface.  Posted here for completeness.

I'm fine with that, please add my:

Acked-by: David S. Miller <davem@davemloft.net>
