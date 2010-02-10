Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab0BJQyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 11:54:37 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54699 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab0BJQyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:54:35 -0500
Subject: Re: [PATCH 1/1 net-next] virtio_net: remove send queue
From: Shirley Ma <mashirle@us.ibm.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, rusty@rustcorp.com.au,
       mst@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1265674482.4484.10.camel@localhost.localdomain>
References: <1265674482.4484.10.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Feb 2010 08:54:30 -0800
Message-ID: <1265820870.23239.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

netperf results showed about 20% transmission gain with this patch for
virtio_net.

Thanks
Shirley

