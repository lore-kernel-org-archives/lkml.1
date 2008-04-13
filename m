Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbYDMWqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbYDMWqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757091AbYDMWp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:45:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52192 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931AbYDMWp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:45:57 -0400
Date: Sun, 13 Apr 2008 23:45:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix typos in Documentation/filesystems/seq_file.txt
Message-ID: <20080413224547.GS9785@ZenIV.linux.org.uk>
References: <1208111201-15698-1-git-send-email-dmitri.vorobiev@gmail.com> <20080413151020.bfa62f58.randy.dunlap@oracle.com> <48028841.900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48028841.900@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 02:25:05AM +0400, Dmitri Vorobiev wrote:

> Actually, I was doubting whether the "2 spaces" thing was
> intentional or not. The overwhelming majority of the sentences in
> this document use only one space after a period, however, and this
> made me decide that the "2 spaces" thing had not been deliberate
> but just a typo.
> 
> Are there any rules about using spaces after a period at the end
> of a sentence?

See Knuth (TeXbook) for the story on that...
