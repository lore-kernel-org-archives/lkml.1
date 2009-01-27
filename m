Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZA0Hk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZA0Hk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 02:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZA0HkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 02:40:18 -0500
Received: from vps1.tull.net ([66.180.172.116]:43883 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751670AbZA0HkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 02:40:17 -0500
Date: Tue, 27 Jan 2009 18:40:09 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Trivial Kernel Patches <trivial@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [TRIVIAL PATCH 00/20] Fix misspelling of "firmware"
Message-ID: <20090127074009.GC12465@mail.local.tull.net>
References: <20090126015921.15168.97302.stgit@marcab.local.tull.net> <alpine.LNX.1.10.0901261059560.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0901261059560.5377@jikos.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 11:00:32AM +0100, Jiri Kosina wrote:
> I will fold all this into single patch and apply.

Ok Jiri. Just to note - last time I submitted a single patch like this
("fix use of loose" in April 2008) to trivial@, the patch frequently
failed to merge due to some of the files being modified, renamed
etc in the meantime, and the patch got dropped. When I split it into
one patch per file and sent them to subsystem maintainers, about 90%
of the patches were merged.

So my impression is that multiple single file patches are more
successful. It should be easier for you to drop any patches which
fail to merge due to other work. But if you think a single patch
is best, I'll submit a single patch.

Nick.
