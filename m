Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbYDNDKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbYDNDKU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 23:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYDNDKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 23:10:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34021 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbYDNDKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 23:10:07 -0400
Date: Mon, 14 Apr 2008 04:09:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>, akpm@linux-foundation.org,
       corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix typos in Documentation/filesystems/seq_file.txt
Message-ID: <20080414030958.GT9785@ZenIV.linux.org.uk>
References: <1208111201-15698-1-git-send-email-dmitri.vorobiev@gmail.com> <20080413151020.bfa62f58.randy.dunlap@oracle.com> <48028841.900@gmail.com> <20080413224547.GS9785@ZenIV.linux.org.uk> <20080413190916.57cede66.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413190916.57cede66.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 07:09:16PM -0700, Randy Dunlap wrote:

> AFAIK, 2 spaces at the end of sentences is a typewriter-ism, for easier
> visual separation of sentences.
> Probably (just guessing here) has to do with monospace fonts vs.
> (not having) proportional ones there (usually).

In a sense...  Basically, the real rules are
	* inter-sentence space is naturally wider than inter-word one
	* if you need to stretch line, inter-sentence spaces get
proportionally more than inter-word ones.
	* if you need to shrink line, they get proportionally less.
	* there are fun extra considerations for quoted sentences and
friends.

For monospace almost nothing of that can be applied, but the first part
(wider inter-sentence spaces) is more painful to ignore.  The ratio for
normally typeset text is going to be less than 2, but it's easier on
eyes to approximate it with 2 than with 1...
