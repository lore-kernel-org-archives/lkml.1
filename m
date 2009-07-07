Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbZGGLZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbZGGLZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 07:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbZGGLZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 07:25:47 -0400
Received: from mail2.shareable.org ([80.68.89.115]:56667 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbZGGLZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 07:25:46 -0400
Date: Tue, 7 Jul 2009 12:25:29 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, tridge@samba.org,
       Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090707112529.GD5690@shareable.org>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <19019.16217.291678.588673@samba.org> <4A4B4D1D.8070308@panasas.com> <1246463087.3894.51.camel@mulgrave.site> <20090706204127.GD13638@shareable.org> <4A531D52.6040508@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A531D52.6040508@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> I wish the lawyers people would come forward, as promised,,and explain what
> are the constraints on the short_name, given a long_name is present.
> I'm still waiting for that private mail in my e-box. If the names do not
> correspond at all but are both valid, why is that a problem?

To be fair Tridge said there is a reason.

The only problem is we don't know what it is...

-- Jamie
