Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118AbYH1PYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbYH1PYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 11:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYH1PYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 11:24:09 -0400
Received: from rrzmta1.rz.uni-regensburg.de ([194.94.155.51]:18948 "EHLO
	rrzmta1.rz.uni-regensburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301AbYH1PYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 11:24:08 -0400
From: "Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de>
Organization: Universitaetsklinikum Regensburg
To: Jiri Kosina <jkosina@suse.cz>
Date: Thu, 28 Aug 2008 17:23:43 +0200
MIME-Version: 1.0
Subject: Re: SLES10 SP1 (x86_64): Hard-hang when using NFSv4 from HP-UX
CC: linux-kernel@vger.kernel.org
Message-ID: <48B6DF1E.7460.1183C391@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
In-reply-to: <Pine.LNX.4.64.0808281336300.28540@twin.jikos.cz>
References: <48B69CE9.12245.108123EC@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>, <Pine.LNX.4.64.0808281336300.28540@twin.jikos.cz>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Content-Conformance: HerringScan-0.27/Sophos-P=4.29.0+V=4.29+U=2.07.201+R=05 May 2008+T=405480@20080828.151647Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 Aug 2008 at 13:37, Jiri Kosina wrote:

> On Thu, 28 Aug 2008, Ulrich Windl wrote:
> 
> > I'm fighting for a while with using NFSv4 provided by HP-UX 11.31 (ONCplus 
> > B.11.31.04 (ONC+ 2.3)) on a SLES10 SP1 (x86_64) client. HP's NFS is basically that 
> > from Sun. The problems are:
> [ ... ]
> > Mounting the filesystems as NFSv3 causes no problems at all, using NFSv4 makes 
> > every file open() attempt to hang hard. I must "kill -9" the processes. Even 
> > "umount -vat nfs4" hangs on umount().
> 
> Sorry, but this mailinglist would be appropriate only if this happens 
> still with current vanilla kernel.
> 
> Otherwise, you should report this problem to your vendor (Novell bugzilla 
> in this case).

Hi!

(ingoring the fact your opinion may be influenced by SUSE/Novell)

Are you saying that SUSE/Novell added bugs regarding NFS4 that are not present in 
the vanilla kernel, or are you saying that the vanilla kernel may have fixed NFSv4 
bugs that SUSE/Novell did not fix? Why shouldn't anybody be interested in the fact 
that there are problems?

Regards,
Ulrich

