Return-Path: <linux-kernel-owner+w=401wt.eu-S933358AbXBXDOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358AbXBXDOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 22:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933359AbXBXDOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 22:14:25 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:11197 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933358AbXBXDOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 22:14:24 -0500
Date: Fri, 23 Feb 2007 19:13:44 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm/mincore: Return EFAULT when passed an invalid address.
Message-ID: <20070224031344.GR7920@ca-server1.us.oracle.com>
Mail-Followup-To: Hugh Dickins <hugh@veritas.com>,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20070223225847.GL7920@ca-server1.us.oracle.com> <20070223231112.GM7920@ca-server1.us.oracle.com> <Pine.LNX.4.64.0702240052360.9507@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702240052360.9507@blonde.wat.veritas.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 24, 2007 at 01:05:27AM +0000, Hugh Dickins wrote:
> No, I think you're getting confused by the way Linus uses access_ok
> on the address range given with the access_ok on the vector address.

	Whoops.  Sorry for the noise.

Joel

-- 

Life's Little Instruction Book #451

	"Don't be afraid to say, 'I'm sorry.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
