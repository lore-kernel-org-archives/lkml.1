Return-Path: <linux-kernel-owner+w=401wt.eu-S1759850AbZADXNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850AbZADXNa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbZADXNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:13:07 -0500
Received: from fhw-relay07.plus.net ([212.159.14.148]:52692 "EHLO
	fhw-relay07.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbZADXNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:13:06 -0500
Message-ID: <49614284.8040201@yahoo.com>
Date: Sun, 04 Jan 2009 23:13:08 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Rob Landley <rob@landley.net>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
References: <fa.P4z5CJpM0xT37PWJuOuCHDkO76o@ifi.uio.no> <fa.eOwOqydZi0qs6K1nmNxBFGQMV40@ifi.uio.no> <fa.26o5IHCAC3TQdXupl62CLYwQ+Wk@ifi.uio.no>
In-Reply-To: <fa.26o5IHCAC3TQdXupl62CLYwQ+Wk@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: cc9e2fea6efa4cacf2d5d7d1e627a146
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Is there linux filesystem that can handle that? I know jffs2, but
> that's unsuitable for stuff like USB thumb drives, right?

This raises the question that if nothing can handle it which FS is the 
least bad? The last I heard people were saying that with cheap SSDs the 
recommendation was FAT [1] but in the future btrfs, nilfs and logfs 
would be better.

[1] http://lkml.org/lkml/2008/10/14/129
