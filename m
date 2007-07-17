Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbXGQEcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbXGQEcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 00:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbXGQEbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 00:31:55 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:50385 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbXGQEby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 00:31:54 -0400
Date: Tue, 17 Jul 2007 05:31:53 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] more drm patches for 2.6.23-rc1
In-Reply-To: <alpine.LFD.0.999.0707162055380.19166@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707170530480.23577@skynet.skynet.ie>
References: <Pine.LNX.4.64.0707170212310.2500@skynet.skynet.ie>
 <alpine.LFD.0.999.0707162055380.19166@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Please pull the 'drm-patches' branch from:

ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

Could you re-pull?

There are two patches, one fixes a missed typedef for Sis and one adds the 
idr_init that fell out of the drawable changeset.. which should fix any 
hangs..

Wow I'm really bad maintainer when I don't have my test machines...

Dave.

-- 
David Airlie, Software Engineer
http://www.skynet.ie/~airlied / airlied at skynet.ie
Linux kernel - DRI, VAX / pam_smb / ILUG

