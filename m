Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYFBMFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYFBMFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 08:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYFBMFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 08:05:40 -0400
Received: from styx.suse.cz ([82.119.242.94]:39837 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751996AbYFBMFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:05:39 -0400
Date: Mon, 2 Jun 2008 14:05:38 +0200
From: Jan Kara <jack@suse.cz>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, jack@suse.cz,
       jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [PATCH 0/5] jbd: possible filesystem corruption fixes (take 2)
Message-ID: <20080602120538.GK30613@duck.suse.cz>
References: <4843CE15.6080506@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4843CE15.6080506@hitachi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 02-06-08 19:40:21, Hidehiro Kawai wrote:
> Subject: [PATCH 0/5] jbd: possible filesystem corruption fixes (take 2)
  Just a small note - repeating the subject in the changelog makes it a bit
harder for Andrew to merge the patches. Standard merging scripts prepend
subject of the email to the changelog below and so in your case the message
would be there twice... Just that you know when you create the patch series
next time.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
