Return-Path: <linux-kernel-owner+w=401wt.eu-S1761767AbXGJRtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761767AbXGJRtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbXGJRt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:49:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:40240 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbXGJRt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:49:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=q8j2oQepj928YybC3EaEzr+rbScDkevuu1/0ZzHi7kBg8LopEwSZRW5fTJ3VYk/sFCwvjwB9uMAWdiAH1apgJTlxZbCTiGgGrXf6L7vP8HfUbFOx/dXO0/u5XdiI0Ok10XwJUo9oRx0uvGS6Cp+IuKoO2BQBIk1X34lg4frx8sU=
Date: Tue, 10 Jul 2007 21:49:23 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: ext2 reservations (Re: -mm merge plans for 2.6.23)
Message-ID: <20070710174923.GA5751@martell.zuzino.mipt.ru>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> ext2-reservations.patch
> 
>  Still needs decent testing.

Was this oops silently fixed?
http://lkml.org/lkml/2007/3/2/138
2.6.21-rc2-mm1: EIP is at ext2_discard_reservation+0x1c/0x52

I still have that ext2 partition backed up.

