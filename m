Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbYGKUDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbYGKUDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYGKUCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:02:53 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:57336 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYGKUCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:02:52 -0400
Date: Fri, 11 Jul 2008 13:02:14 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: joel.becker@hawkmoon.kerlabs.com, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: Re: [BUGFIX][PATCH v2 1/2] configfs: Prevent userspace from
	creating new entries under attaching directories
Message-ID: <20080711200214.GA22577@mail.oracle.com>
Mail-Followup-To: Louis Rilling <louis.rilling@kerlabs.com>,
	joel.becker@hawkmoon.kerlabs.com, linux-kernel@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com> <1215183366-17479-2-git-send-email-louis.rilling@kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215183366-17479-2-git-send-email-louis.rilling@kerlabs.com>
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

On Fri, Jul 04, 2008 at 04:56:05PM +0200, Louis Rilling wrote:
> Changelog:
>   - Rename configfs_validate_dir() in configfs_dir_set_ready()
>   - Introduce configfs_dirent_is_ready() helper to unbloat a bit
>     CONFIGFS_USET_CREATING checks

	Looks good.

Joel

-- 

"Lately I've been talking in my sleep.
 Can't imagine what I'd have to say.
 Except my world will be right
 When love comes back my way."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
