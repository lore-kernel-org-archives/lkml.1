Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbXKBM21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbXKBM21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 08:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbXKBM2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 08:28:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58237 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbXKBM2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 08:28:18 -0400
Subject: Re: [AppArmor 19/45] Add struct vfsmount parameters to vfs_rename()
From: Peter Zijlstra <peterz@infradead.org>
To: 7eggert@gmx.de
Cc: Al Viro <viro@ftp.linux.org.uk>, John Johansen <jjohansen@suse.de>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>
In-Reply-To: <E1IntXa-0001JL-Qw@be1.7eggert.dyndns.org>
References: <9irkY-83N-5@gated-at.bofh.it> <9iruz-7b-23@gated-at.bofh.it>
	 <9irXD-Jf-25@gated-at.bofh.it> <9iC6y-nT-1@gated-at.bofh.it>
	 <9iE8n-3zk-1@gated-at.bofh.it>  <E1IntXa-0001JL-Qw@be1.7eggert.dyndns.org>
Content-Type: text/plain
Date: Fri, 02 Nov 2007 13:28:06 +0100
Message-Id: <1194006486.27652.362.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-02 at 11:14 +0100, Bodo Eggert wrote:

> /me prepares for the impact of a large round object on earth.

/me ponders the implications of the impact of a 2 dimensional object
colliding with a 3 dimensional object in real life.

