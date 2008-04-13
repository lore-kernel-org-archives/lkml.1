Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbYDMX4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbYDMX4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYDMX4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:56:09 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:55912 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1753015AbYDMX4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:56:08 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Mon, 14 Apr 2008 09:55:53 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix typos in Documentation/filesystems/seq_file.txt
Message-ID: <20080413235553.GG29599@tull.net>
References: <1208111201-15698-1-git-send-email-dmitri.vorobiev@gmail.com> <20080413151020.bfa62f58.randy.dunlap@oracle.com> <48028841.900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48028841.900@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 02:25:05AM +0400, Dmitri Vorobiev wrote:
> Actually, I was doubting whether the "2 spaces" thing was
> intentional or not. The overwhelming majority of the sentences in
> this document use only one space after a period, however, and this
> made me decide that the "2 spaces" thing had not been deliberate
> but just a typo.

The 2-spaces ones were probably reformatted using 'fmt'. If fmt joins
a line ending in a period, it will use 2 spaces. It does not change the
spacing in non-joined lines, despite what the manpage says.

Nick.
