Return-Path: <linux-kernel-owner+w=401wt.eu-S1762314AbYEUAGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762314AbYEUAGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbYEUAGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:06:03 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23830 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbYEUAGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:06:01 -0400
Date: Tue, 20 May 2008 16:53:01 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] ocfs2: rename user_stack{,_ops}
Message-ID: <20080520235301.GM26609@mail.oracle.com>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
References: <20080520225509.GD16264@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520225509.GD16264@cs181133002.pp.htv.fi>
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

On Wed, May 21, 2008 at 01:55:09AM +0300, Adrian Bunk wrote:
> This patch therefore prefixes the user_stack{,_ops} names with ocfs2_

	Thanks for reporting this.  Al already reported it and a fix is
in ocfs2.git.  We change the name entirely so that grep of user_stack
doesn't match it at all.

Joel

-- 

"Nobody loves me,
 Nobody seems to care.
 Troubles and worries, people,
 You know I've had my share."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
