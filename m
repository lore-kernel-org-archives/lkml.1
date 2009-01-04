Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbZADN37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbZADN37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 08:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbZADN3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 08:29:45 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36220 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZADN3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 08:29:44 -0500
Date: Sun, 4 Jan 2009 22:28:38 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: Btrfs for mainline
Cc: kosaki.motohiro@jp.fujitsu.com, Chris Mason <chris.mason@oracle.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>
In-Reply-To: <adaocyppco5.fsf@cisco.com>
References: <1230932112.7538.82.camel@think.oraclecorp.com> <adaocyppco5.fsf@cisco.com>
Message-Id: <20090104222638.C7FD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> One possibility would be to mimic ext4 and register the fs as "btrfsdev"
> until it's considered stable enough for production.  I agree with the
> consensus that we want to use the upstream kernel as a nexus for
> coordinating btrfs development, so I don't think it's worth waiting a
> release or two to merge something.

I like this idea.
I also want to test btrfs. but I'm not interested out of tree code.



