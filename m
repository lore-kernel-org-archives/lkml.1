Return-Path: <linux-kernel-owner+w=401wt.eu-S1751183AbXBMIo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183AbXBMIo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbXBMIo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:44:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbXBMIoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:44:55 -0500
From: Neil Brown <neilb@suse.de>
To: Andrew Burgess <aab@cichlid.com>
Date: Tue, 13 Feb 2007 19:44:17 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17873.31329.972230.498090@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: md: md6_raid5 crash 2.6.20
In-Reply-To: message from Andrew Burgess on Monday February 12
References: <200702121628.l1CGSwhJ019548@cichlid.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday February 12, aab@cichlid.com wrote:
> >However
> >this "kernel BUG" is something newly introduced in 2.6.20 which should
> >be fixed in 2.6.20.1.  Patch is below.
> 
> I am using raid6. Am I at risk after applying this patch?

I'm not going to say "you are not at risk after applying this patch"
as one never knows about hidden bugs until one finds them.

However this patch is equally applicable to raid6 and if you apply it
you should be able to continue using your raid6 with as much
confidence as before...

NeilBrown
