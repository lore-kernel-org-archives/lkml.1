Return-Path: <linux-kernel-owner+w=401wt.eu-S1759200AbYFPX1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbYFPX1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 19:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758674AbYFPX1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 19:27:37 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:16427 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378AbYFPX1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 19:27:36 -0400
Date: Mon, 16 Jun 2008 16:26:57 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 0/5][BUGFIX] configfs: Fix deadlock of rename() vs
	rmdir()
Message-ID: <20080616232657.GE6441@mail.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <20080616170057.399713501@kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616170057.399713501@kerlabs.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 07:00:57PM +0200, Louis Rilling wrote:
> This patchset fixes the deadlock described below. This second version of the
> patchset fixes another long-standing bug in symlinks locking. Please read the
> headers of the third and fourth patches for a detailed explanation of the
> bugfixes. The last patch fixes a new behavior introduced by the deadlock fix,
> and that ones could find undesirable. Whether it is really needed or not is
> debatable.

	Ok, this is in-tree for the next merge.  Thanks.

Joel

-- 

"There is no sincerer love than the love of food."  
         - George Bernard Shaw 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
