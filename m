Return-Path: <linux-kernel-owner+w=401wt.eu-S932674AbZLNWKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbZLNWKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932712AbZLNWJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:09:56 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:44253 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698AbZLNWJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:09:54 -0500
Subject: Re: [PATCH v2 1/4] Defer skb allocation -- add destroy buffers
 function for virtio
From: Shirley Ma <mashirle@us.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
       netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <200912141355.59678.rusty@rustcorp.com.au>
References: <1258697359.7416.14.camel@localhost.localdomain>
	 <1260534506.30371.6.camel@localhost.localdomain>
	 <1260534805.30371.10.camel@localhost.localdomain>
	 <200912141355.59678.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Mon, 14 Dec 2009 14:09:33 -0800
Message-Id: <1260828573.8716.106.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Rusty.

I agree with all these comments, will work on them.

Shirley

