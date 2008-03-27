Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbYC0EyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbYC0EyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 00:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbYC0Exv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 00:53:51 -0400
Received: from ozlabs.org ([203.10.76.45]:33663 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYC0Exu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 00:53:50 -0400
Subject: Re: [PATCH] Give futex init a proper name
From: Benjamin Herrenschmidt <benh@ozlabs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20080326210038.e54b6180.akpm@linux-foundation.org>
References: <20080327035249.6F774DDF4D@ozlabs.org>
	 <20080326210038.e54b6180.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 15:53:00 +1100
Message-Id: <1206593580.10106.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-26 at 21:00 -0700, Andrew Morton wrote:
> heh, I seem to remember doing about fifty of these in netfilter code a
> while back.
> 
> You have a way to go - there are thirty-odd just in the crypto code.

Heh, well, let's merge that one and I'll see if I can be bothered fixing
the crypto ones :-)

Cheers,
Ben.


