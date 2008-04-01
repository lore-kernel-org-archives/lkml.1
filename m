Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbYDAXNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbYDAXNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 19:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYDAXNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 19:13:44 -0400
Received: from ozlabs.org ([203.10.76.45]:39572 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbYDAXNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 19:13:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18418.49494.457893.866627@cargo.ozlabs.ibm.com>
Date: Wed, 2 Apr 2008 10:12:22 +1100
From: Paul Mackerras <paulus@samba.org>
To: Bartlomiej Sieka <tur@semihalf.com>
Cc: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: Please pull powerpc.git merge branch
In-Reply-To: <47ED6BE5.9060807@semihalf.com>
References: <18412.58902.189124.391104@cargo.ozlabs.ibm.com>
	<47ED6BE5.9060807@semihalf.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Sieka writes:

> What about http://patchwork.ozlabs.org/linuxppc/patch?id=17525 ? I don't
> see it in the merge branch of your repository, and it would be nice to
> get it upstream as it fixes boot problems on some MPC5200-based boards.

It needs a proper stand-alone commit message and an acked-by from
Grant.  The commit message should explain why you are making the
changes you are making rather than just saying "the bulk of this patch
is taken from http://...".

Paul.
