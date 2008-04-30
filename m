Return-Path: <linux-kernel-owner+w=401wt.eu-S1760451AbYD3Rny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451AbYD3Rny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762535AbYD3Rnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:43:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761843AbYD3Rnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:43:35 -0400
Date: Wed, 30 Apr 2008 10:43:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext3: Fix typos in messages and comments (journalled ->
 journaled)
Message-Id: <20080430104330.66c44d4f.akpm@linux-foundation.org>
In-Reply-To: <1209567981639-git-send-email-jack@suse.cz>
References: <12095679813226-git-send-email-jack@suse.cz>
	<12095679812375-git-send-email-jack@suse.cz>
	<12095679812452-git-send-email-jack@suse.cz>
	<1209567981639-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 17:06:15 +0200
Jan Kara <jack@suse.cz> wrote:

> -					"EXT3-fs: Cannot change journalled "
> +					"EXT3-fs: Cannot change journaled "

hrm, who said?

Dictionary.com recognises neither.

google(journalled) = 520,000
google(journaled) = 652,000

akpm:/usr/src/25> grep journalled fs/ext3/*.c|wc -l
17
akpm:/usr/src/25> grep journaled fs/ext3/*.c|wc -l 
6


