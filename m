Return-Path: <linux-kernel-owner+w=401wt.eu-S1759768AbZLOK2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768AbZLOK2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759746AbZLOK2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:28:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44889 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758939AbZLOK2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:28:34 -0500
Subject: Re: [folded]
 kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch removed from
 -mm tree
From: Peter Zijlstra <peterz@infradead.org>
To: akpm@linux-foundation.org
Cc: h-shimamoto@ct.jp.nec.com, joe@perches.com, mingo@elte.hu,
       nooiwa@miraclelinux.com, mm-commits@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200912150108.nBF18TNx015047@imap1.linux-foundation.org>
References: <200912150108.nBF18TNx015047@imap1.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Dec 2009 11:28:02 +0100
Message-ID: <1260872882.4165.353.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 17:08 -0800, akpm@linux-foundation.org wrote:
> s/_rl/_ratelimited/g

do we feel this pr_* wankery is worth the hassle? I'd as soon send a
patch removing all this crap.
