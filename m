Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752369AbYLSP7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbYLSP7b (ORCPT <rfc822;akpm@linux-foundation.org>);
	Fri, 19 Dec 2008 10:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYLSP6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 10:58:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36392 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbYLSP6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 10:58:35 -0500
From: y@redhat.com
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v5 0/6] Add preadv & pwritev system calls.
Date: Fri, 19 Dec 2008 16:58:19 +0100
Message-Id: <1229702305-23027-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

  Hi folks,

Next round of the preadv & pwritev patch series, addressing review
comments:

 * Common code for the compat syscall versions is factored
   out in preparing patches.  
 * Added prototypes to syscall.h
 * Fixup some whitespace damage.

It's also the last release before I fall off the internet for the x-mas
and new-year holidays.  I'll be online again starting Jan 5th and will
deal with the remaining issues (if any) then.

cheers,
  Gerd

