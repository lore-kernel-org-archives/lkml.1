Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbZF2NCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbZF2NCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 09:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbZF2NCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 09:02:25 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53131 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbZF2NCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 09:02:25 -0400
Subject: Re: [PATCH] hugetlbfs: publish HUGETLBFS_MAGIC via linux/magic.h
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: nick black <dank@qemfd.net>
Cc: William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       man-pages <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       jmorris@namei.org
In-Reply-To: <20090629130023.GA16674@qemfd.net>
References: <20090629121657.GA9848@qemfd.net>
	 <84144f020906290539m3d24af6ap37f9da9371b786dd@mail.gmail.com>
	 <20090629130023.GA16674@qemfd.net>
Date: Mon, 29 Jun 2009 16:02:26 +0300
Message-Id: <1246280546.6364.13.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-29 at 09:00 -0400, nick black wrote:
> Thanks for the review, Pekka, and I couldn't agree more. Here's a second
> version of the patch, a rather more equal-opportunity unification
> of magic numbers (I'll resend with a new Subject if that's preferred):
> 
> Signed-off-by: Nick Black <dank@qemfd.net>

Looks good to me!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

To both patches.

