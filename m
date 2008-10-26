Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbYJZOYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbYJZOYV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 10:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbYJZOYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 10:24:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:47725 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbYJZOYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 10:24:12 -0400
Message-ID: <f3f71ab90810260724i4db015d8r2eb562d9ef142fe1@mail.gmail.com>
Date: Sun, 26 Oct 2008 14:24:10 +0000
From: "Mike Lothian" <mike@fireburn.co.uk>
To: linux-kernel@vger.kernel.org
Subject: Reiser4 and d_alloc_anon
Cc: reiserfs-devel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Reiser4 still uses d_alloc_anon and is't compiling on Linus's tree

I took a look at:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=440037287c5ebb07033ab927ca16bb68c291d309

But it looks like it isn't a case of renaming to d_obtain_alias

Does any one have a patch for this?

Cheers

Mike
