Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbYGKUGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbYGKUGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYGKUGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:06:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:30382 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbYGKUGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:06:09 -0400
Date: Fri, 11 Jul 2008 13:05:41 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: joel.becker@hawkmoon.kerlabs.com, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: Re: [BUGFIX][PATCH v2 2/2] configfs: Lock new directory inodes
	before removing on cleanup after failure
Message-ID: <20080711200541.GB22577@mail.oracle.com>
Mail-Followup-To: Louis Rilling <louis.rilling@kerlabs.com>,
	joel.becker@hawkmoon.kerlabs.com, linux-kernel@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com> <1215183366-17479-3-git-send-email-louis.rilling@kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215183366-17479-3-git-send-email-louis.rilling@kerlabs.com>
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

On Fri, Jul 04, 2008 at 04:56:06PM +0200, Louis Rilling wrote:
> Changelog:
>   - Improve comments and braces as requested by Joel

	Also looking good, I want to test them and then send them along.

Joel

-- 

"When I am working on a problem I never think about beauty. I
 only think about how to solve the problem. But when I have finished, if
 the solution is not beautiful, I know it is wrong."
         - Buckminster Fuller

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
