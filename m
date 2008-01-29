Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbYA2Hpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbYA2Hpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 02:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYA2Hph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 02:45:37 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:62987 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbYA2Hpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 02:45:36 -0500
Date: Mon, 28 Jan 2008 23:44:02 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Greg KH <gregkh@suse.de>
Cc: Mark Fasheh <mark.fasheh@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: Re: [git pull] Fix recent Ocfs2 breakage
Message-ID: <20080129074402.GA27097@ca-server1.us.oracle.com>
Mail-Followup-To: Greg KH <gregkh@suse.de>,
	Mark Fasheh <mark.fasheh@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <20080129033307.GE23506@ca-server1.us.oracle.com> <20080129050804.GA2285@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129050804.GA2285@suse.de>
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

On Mon, Jan 28, 2008 at 09:08:04PM -0800, Greg KH wrote:
> And please please please please document stuff like this, and all of the
> different files you have in this subdirectory in Documentation/ABI/ so

	Huh, I didn't know Documentation/ABI existed.  That would
certainly help in the future.

> those of us who are trying to figure out the code (and there's still
> parts of the kobject usage I'm pretty sure is not correct) can have a

	ocfs2 kobject usage, or other folks'?  If there's anything in
the ocfs2 usage that you are unsure of, feel free to ask!

Joel

-- 

"Also, all of life's big problems include the words 'indictment' or
	'inoperable.' Everything else is small stuff."
	- Alton Brown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
