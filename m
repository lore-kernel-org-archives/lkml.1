Return-Path: <linux-kernel-owner+w=401wt.eu-S1763922AbYBLUsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763922AbYBLUsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYBLUsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:48:43 -0500
Received: from twin.jikos.cz ([213.151.79.26]:38285 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbYBLUsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:48:41 -0500
Date: Tue, 12 Feb 2008 21:48:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Chris Nolan <chrisonthelists@cenolan.com>
cc: linux-kernel@vger.kernel.org,
       =?ISO-8859-2?Q?Tobias_M=FCller?= <Tobias_Mueller@twam.info>
Subject: Re: [PATCH] hid, 2.6.23 - add support for new macbook and apple
 aluminum keyboard "fn" key
In-Reply-To: <fosskb$klp$1@ger.gmane.org>
Message-ID: <Pine.LNX.4.64.0802122143280.7699@twin.jikos.cz>
References: <fosskb$klp$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Chris Nolan wrote:

> Seeking feedback for this patch which adds support for the "fn" key on 
> the new macbook (3,1) and apple aluminum keyboard. I have tested this 
> with kernel 2.6.23 (both 2.6.23.9 and 2.6.23.15) under Fedora 8 and it 
> seems to work for me.

Hi Chris,

Some part of the patch is already in 2.6.25-rc1 -- please see commit 
a45d82d19a6c2a717bcc33cff243199b77fa0082, which adds support for Apple 
Aluminium keyboards. So the patch would need some changes that it would 
apply on top of current tree.

Also, if you could get Signed-off-by for the new patch from the author(s) 
of the original patch, that would be great.

> The original patch was created by Martin Szulecki (of mactel-linux) and 
> Chris Irwin. I can't take any credit - I've just found that it works and 
> would like to see it tested and committed upstream if possible.
> I am linking to the patch because a) its quite long, and b) I am not sure how
> to prevent thunderbird from wrapping the lines and I'd hate to annoy the list
> with some malformed garbage.
> Patch is here:
> https://bugzilla.redhat.com/attachment.cgi?id=294650

Also, Tobias (added to CC) seems to be currently working on adding support 
for a subset of keyboards that this patch adds. Tobias -- it seems like 
this patch is handling a superset of what your patch does, right?

It would be great if you could put this all together into one condensated 
patch which I could merge into my tree.

Thanks guys!

-- 
Jiri Kosina
SUSE Labs

