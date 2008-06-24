Return-Path: <linux-kernel-owner+w=401wt.eu-S1759990AbYFXRKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbYFXRKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757518AbYFXRJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:09:52 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:21241 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbYFXRJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:09:51 -0400
Date: Tue, 24 Jun 2008 10:04:21 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 0/2]v2 configfs: symlink() fixes
Message-ID: <20080624170421.GC4184@ca-server1.us.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <1214223378-14203-1-git-send-email-louis.rilling@kerlabs.com> <20080623222043.GG592@mail.oracle.com> <20080624132004.GF7621@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624132004.GF7621@hawkmoon.kerlabs.com>
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

On Tue, Jun 24, 2008 at 03:20:04PM +0200, Louis Rilling wrote:
> On Mon, Jun 23, 2008 at 03:20:44PM -0700, Joel Becker wrote:
> > 	Silly question: you've tested this, right?
> 
> Yup. I tested this on Linux 2.6.26-rc5 with a modified example_configfs.c
> (attached), and on a backport for 2.6.20 with my own subsystem (based on
> Kerrighed http://www.kerrighed.org/wiki/index.php/SchedConfig ).

	Excellent!

> Do you have some regression tests?

	No.  I've been meaning to create a complex configfs_example with
lots of different scenarios so I could write some.  Feel free to do so!
	Thank you for sending this along.

Joel

-- 

"There is a country in Europe where multiple-choice tests are
 illegal."
        - Sigfried Hulzer

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
