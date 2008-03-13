Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbYCMMDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbYCMMDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYCMMDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:03:46 -0400
Received: from styx.suse.cz ([82.119.242.94]:40966 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752559AbYCMMDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:03:46 -0400
Date: Thu, 13 Mar 2008 13:03:44 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Quota cleanups and fixes
Message-ID: <20080313120344.GB12523@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  in the following emails will come three minor quota fixes and cleanups:

[PATCH 1/3] Add possibly missing iput() when quotaon and quotaoff races
[PATCH 2/3] Remove superfluous DQUOT_OFF() in fs/namespace.c
[PATCH 3/3] Various style cleanups

  Would you please put them to -mm? Thanks.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
