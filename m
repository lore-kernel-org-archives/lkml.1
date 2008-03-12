Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbYCLWNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbYCLWNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYCLWNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:13:30 -0400
Received: from ozlabs.org ([203.10.76.45]:42823 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737AbYCLWN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:13:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] aio_write should tell userspace about partial writes
Date: Thu, 13 Mar 2008 09:12:45 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Zach Brown <zach.brown@oracle.com>, bcrl@kvack.org, linux-aio@kvack.org
References: <200803120939.59915.rusty@rustcorp.com.au> <alpine.LFD.1.00.0803121255400.3557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803121255400.3557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803130912.45824.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 06:59:36 Linus Torvalds wrote:
> On Wed, 12 Mar 2008, Rusty Russell wrote:
> > [ Linus, please apply.  This patch was discussed and acked before,
> >   but somehow got lost. ]
>
> Rusty, please *look* at your patches.

Damn, sorry.  I should never send mail before coffee.

(Actually, I'm sending this before coffee, but that's OK because I can't 
possibly scrwe this up.)

Rusty.
