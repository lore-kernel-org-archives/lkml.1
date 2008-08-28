Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbYH1Lhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbYH1Lhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 07:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYH1Lhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 07:37:45 -0400
Received: from twin.jikos.cz ([213.151.79.26]:51137 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbYH1Lho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 07:37:44 -0400
Date: Thu, 28 Aug 2008 13:37:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: SLES10 SP1 (x86_64): Hard-hang when using NFSv4 from HP-UX
In-Reply-To: <48B69CE9.12245.108123EC@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
Message-ID: <Pine.LNX.4.64.0808281336300.28540@twin.jikos.cz>
References: <48B69CE9.12245.108123EC@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, Ulrich Windl wrote:

> I'm fighting for a while with using NFSv4 provided by HP-UX 11.31 (ONCplus 
> B.11.31.04 (ONC+ 2.3)) on a SLES10 SP1 (x86_64) client. HP's NFS is basically that 
> from Sun. The problems are:
[ ... ]
> Mounting the filesystems as NFSv3 causes no problems at all, using NFSv4 makes 
> every file open() attempt to hang hard. I must "kill -9" the processes. Even 
> "umount -vat nfs4" hangs on umount().

Sorry, but this mailinglist would be appropriate only if this happens 
still with current vanilla kernel.

Otherwise, you should report this problem to your vendor (Novell bugzilla 
in this case).

-- 
Jiri Kosina
SUSE Labs

