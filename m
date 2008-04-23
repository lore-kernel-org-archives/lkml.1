Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbYDWRmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbYDWRmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 13:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbYDWRmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 13:42:37 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:24534 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbYDWRmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 13:42:35 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS patches (third series, mountinfo merge)
References: <20080423002219.GW27459@ZenIV.linux.org.uk>
	<20080423163509.GZ27459@ZenIV.linux.org.uk>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 23 Apr 2008 10:42:34 -0700
In-Reply-To: <20080423163509.GZ27459@ZenIV.linux.org.uk> (Al Viro's message of
	"Wed, 23 Apr 2008 17:35:09 +0100")
Message-ID: <ada7ieobh85.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Apr 2008 17:42:34.0871 (UTC) FILETIME=[6A01C870:01C8A569]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just curious... do you plan to merge your changes to anon_inodes for
2.6.26?

Thanks,
  Roland
