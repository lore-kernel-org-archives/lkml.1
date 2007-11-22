Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbXKVTXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbXKVTXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 14:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXKVTX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 14:23:27 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57804 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbXKVTX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 14:23:26 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4745D71A.4080407@s5r6.in-berlin.de>
Date: Thu, 22 Nov 2007 20:23:06 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.8) Gecko/20071102 SeaMonkey/1.1.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Ben Collins <ben.collins@ubuntu.com>,
       Dan Dennedy <dan@dennedy.org>, linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH 18/59] drivers/ieee1394: Add missing "space"
References: 1234567 <1195523331-15303-2-git-send-email-joe@perches.com> <1195523331-15303-3-git-send-email-joe@perches.com> <1195523331-15303-4-git-send-email-joe@perches.com> <1195523331-15303-5-git-send-email-joe@perches.com> <1195523331-15303-6-git-send-email-joe@perches.com> <1195523331-15303-7-git-send-email-joe@perches.com> <1195523331-15303-8-git-send-email-joe@perches.com> <1195523331-15303-9-git-send-email-joe@perches.com> <1195523331-15303-10-git-send-email-joe@perches.com> <1195523331-15303-11-git-send-email-joe@perches.com> <1195523331-15303-12-git-send-email-joe@perches.com> <1195523331-15303-13-git-send-email-joe@perches.com> <1195523331-15303-14-git-send-email-joe@perches.com> <1195523331-15303-15-git-send-email-joe@perches.com> <1195523331-15303-16-git-send-email-joe@perches.com> <1195523331-15303-17-git-send-email-joe@perches.com> <1195523331-15303-18-git-send-email-joe@perches.com> <1195523331-15303-19-git-send-email-joe@perches.com>
In-Reply-To: <1195523331-15303-19-git-send-email-joe@perches.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
>  drivers/ieee1394/raw1394.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
...
> -	DBGMSG("arm_read  called by node: %X"
> +	DBGMSG("arm_read  called by node: %X "
...

Committed to linux1394-2.6.git.  Thanks,
-- 
Stefan Richter
-=====-=-=== =-== =-==-
http://arcgraph.de/sr/
