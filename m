Return-Path: <linux-kernel-owner+w=401wt.eu-S1759806AbYDBAzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806AbYDBAzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 20:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbYDBAzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 20:55:23 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:59700 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657AbYDBAzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 20:55:22 -0400
Subject: Re: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26
	(what's in infiniband.git)
From: Shirley Ma <mashirle@us.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
In-Reply-To: <adave31bayd.fsf@cisco.com>
References: <adave31bayd.fsf@cisco.com>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 09:55:55 -0700
Message-Id: <1207068955.4593.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-01 at 13:02 -0700, Roland Dreier wrote:
> - Multiple CQ event vector support.  I still haven't seen any
>    discussions about how ULPs or userspace apps should decide which
>    vector to use, and hence no progress has been made since we
>    deferred this during the 2.6.23 merge window. 

I did some prototype for IPoIB to enable multiple CQ event support. I
did see the approach improved multiple links aggregation performance. I
also see some customers' requirements in userspace. I will start the
discussion as soon as possible. But it would most likely miss 2.6.26
window.

Thanks
Shirley

