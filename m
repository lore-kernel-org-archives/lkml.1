Return-Path: <linux-kernel-owner+w=401wt.eu-S1759583AbYDNCJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbYDNCJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 22:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbYDNCJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 22:09:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:52373 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbYDNCJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 22:09:45 -0400
Date: Sun, 13 Apr 2008 19:09:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>, akpm@linux-foundation.org,
       corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix typos in Documentation/filesystems/seq_file.txt
Message-Id: <20080413190916.57cede66.randy.dunlap@oracle.com>
In-Reply-To: <20080413224547.GS9785@ZenIV.linux.org.uk>
References: <1208111201-15698-1-git-send-email-dmitri.vorobiev@gmail.com>
	<20080413151020.bfa62f58.randy.dunlap@oracle.com>
	<48028841.900@gmail.com>
	<20080413224547.GS9785@ZenIV.linux.org.uk>
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

On Sun, 13 Apr 2008 23:45:47 +0100 Al Viro wrote:

> On Mon, Apr 14, 2008 at 02:25:05AM +0400, Dmitri Vorobiev wrote:
> 
> > Actually, I was doubting whether the "2 spaces" thing was
> > intentional or not. The overwhelming majority of the sentences in
> > this document use only one space after a period, however, and this
> > made me decide that the "2 spaces" thing had not been deliberate
> > but just a typo.
> > 
> > Are there any rules about using spaces after a period at the end
> > of a sentence?
> 
> See Knuth (TeXbook) for the story on that...

I googled that but I don't see the history there.

AFAIK, 2 spaces at the end of sentences is a typewriter-ism, for easier
visual separation of sentences.
Probably (just guessing here) has to do with monospace fonts vs.
(not having) proportional ones there (usually).

---
~Randy
[Yes, I learned to type on a manual typewriter.]
