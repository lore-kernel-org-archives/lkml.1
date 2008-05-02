Return-Path: <linux-kernel-owner+w=401wt.eu-S933558AbYEBAu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbYEBAu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYEBAuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:50:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:12630 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbYEBAuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:50:14 -0400
Date: Thu, 1 May 2008 17:50:09 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Roland <devzero@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: modprobe ocfs2_stack_o2cb warning - duplicate filename o2cb in
	sysfs
Message-ID: <20080502005009.GH19731@mail.oracle.com>
Mail-Followup-To: Roland <devzero@web.de>, linux-kernel@vger.kernel.org
References: <003a01c8abed$7ffe4bf0$6400a8c0@bui.materna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003a01c8abed$7ffe4bf0$6400a8c0@bui.materna.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Roland,
	Thanks for sending this along.  The fix is already queued; it
pretty much blows up for everyone!
http://git.kernel.org/?p=linux/kernel/git/mfasheh/ocfs2.git;a=commit;h=9d80f7539a91c0154e40fc9e4ae5e818dd8f102e

Joel

-- 

"Reality is merely an illusion, albeit a very persistent one."
        - Albert Einstien

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
