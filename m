Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbZIOTZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbZIOTZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758645AbZIOTZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:25:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbZIOTZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:25:39 -0400
Message-Id: <20090915191903.290006007@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Wed, 16 Sep 2009 05:19:03 +1000
From: npiggin@suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch 0/5] bdi writeback fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ran into a few crashes with the bdi writeback stuff. Things are a bit more
stable now. Although I've still got a seemingly unrelated GFP in __d_lookup
that I've seen twice now :(

Thanks,
Nick


