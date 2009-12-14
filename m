Return-Path: <linux-kernel-owner+w=401wt.eu-S932531AbZLNWKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbZLNWKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932742AbZLNWKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:10:41 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:45507 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932614AbZLNWKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:10:36 -0500
Subject: Re: [PATCH v2 2/4] Defer skb allocation -- new skb_set calls &
 chain pages in virtio_net
From: Shirley Ma <mashirle@us.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
       netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <200912141724.49034.rusty@rustcorp.com.au>
References: <1258697359.7416.14.camel@localhost.localdomain>
	 <1260534506.30371.6.camel@localhost.localdomain>
	 <1260535382.30371.20.camel@localhost.localdomain>
	 <200912141724.49034.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Mon, 14 Dec 2009 14:10:08 -0800
Message-Id: <1260828608.8716.107.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Rusty, agree with you, working on them.

Shirley

