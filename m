Return-Path: <linux-kernel-owner+w=401wt.eu-S933445AbYGQVqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933445AbYGQVqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756944AbYGQVp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:45:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:64766 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbYGQVpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:45:55 -0400
Date: Thu, 17 Jul 2008 14:45:12 -0700
From: Joel Becker <Joel.Becker@ORACLE.COM>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Ocfs2-devel] [git patches] Ocfs2 and Configfs updates for
	2.6.27
Message-ID: <20080717214512.GB8283@ca-server1.us.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org,
	ocfs2-devel@oss.oracle.com,
	Andrew Morton <akpm@linux-foundation.org>
References: <20080717175146.GH28014@wotan.suse.de> <alpine.LFD.1.10.0807171056520.2959@woody.linux-foundation.org> <20080717212038.GA8283@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717212038.GA8283@ca-server1.us.oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 02:20:38PM -0700, Joel Becker wrote:
> On Thu, Jul 17, 2008 at 11:01:40AM -0700, Linus Torvalds wrote:
> > I pulled it, but I want to register my protest.
> 
> 	I wish you hadn't, because it won't be to difficult to go back
> to PTR_ERR().  However, don't revert it - that affects some of the
> follow-on patches that were affected by the change.

	I lied.  I'll cleanup the fallout.  You can revert it or wait
for my revert + PTR_ERR.  Let me know if you revert it.

Joel

-- 

"Against stupidity the Gods themselves contend in vain."
	- Friedrich von Schiller

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
