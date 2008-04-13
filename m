Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbYDMWLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbYDMWLV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYDMWLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:11:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24503 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbYDMWLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:11:08 -0400
Date: Sun, 13 Apr 2008 15:10:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: akpm@linux-foundation.org, corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix typos in Documentation/filesystems/seq_file.txt
Message-Id: <20080413151020.bfa62f58.randy.dunlap@oracle.com>
In-Reply-To: <1208111201-15698-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1208111201-15698-1-git-send-email-dmitri.vorobiev@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 22:26:41 +0400 Dmitri Vorobiev wrote:

> A couple of typos crept into the newly added document
> about the seq_file interface. This patch corrects those
> typos and simultaneously deletes a few superfluous blanks.

The "2 spaces after a period at the end of a sentence" was done
on purpose, I feel sure.  It's not a mistake.

The other typo corrections & elimination of trailing whitespace
look good.  Thanks.

> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
> ---
>  Documentation/filesystems/seq_file.txt |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)

---
~Randy
