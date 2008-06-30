Return-Path: <linux-kernel-owner+w=401wt.eu-S1757009AbYF3Oek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbYF3Oek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 10:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYF3Oeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 10:34:31 -0400
Received: from kumera.dghda.com ([80.68.90.171]:1500 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbYF3Oea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 10:34:30 -0400
From: "Duane Griffin" <duaneg@dghda.com>
Date: Mon, 30 Jun 2008 15:34:27 +0100
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
       Sami Liedes <sliedes@cc.hut.fi>, jochen.voss@googlemail.com,
       Jan Kara <jack@suse.cz>, Valdis.Kletnieks@vt.edu,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH, v4] ext3: validate directory entry data before use
Message-ID: <20080630143427.GA5473@dastardly>
References: <200806291857.m5TIv1k5001781@imap1.linux-foundation.org> <1214835522-5414-1-git-send-email-duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214835522-5414-1-git-send-email-duaneg@dghda.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry folks, I hadn't see the bug report from Valdis and Hugh before I
sent out this new version. Please ignore this while I investigate.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
