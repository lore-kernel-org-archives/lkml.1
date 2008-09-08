Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbYIHOtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbYIHOtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYIHOsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:48:53 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42877 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbYIHOsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:48:53 -0400
Date: Mon, 8 Sep 2008 10:47:47 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: miss an unlock in ext4_check_descriptors()
Message-ID: <20080908144747.GI8161@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Li Zefan <lizf@cn.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <48C4D54E.60909@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C4D54E.60909@cn.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I've applied it to the ext4 patch queue.

						- Ted
