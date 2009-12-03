Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbZLCU1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbZLCU1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZLCU1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:27:18 -0500
Received: from cobra.newdream.net ([66.33.216.30]:35758 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbZLCU1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:27:17 -0500
Date: Thu, 3 Dec 2009 12:27:23 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       yehuda@newdream.net
Subject: ceph code review
In-Reply-To: <20090929171511.29836c82.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0912011648590.5806@cobra.newdream.net>
References: <1253641129-28434-1-git-send-email-sage@newdream.net>
 <1253641129-28434-2-git-send-email-sage@newdream.net>
 <1253641129-28434-3-git-send-email-sage@newdream.net>
 <1253641129-28434-4-git-send-email-sage@newdream.net>
 <1253641129-28434-5-git-send-email-sage@newdream.net>
 <1253641129-28434-6-git-send-email-sage@newdream.net>
 <1253641129-28434-7-git-send-email-sage@newdream.net>
 <20090929171511.29836c82.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009, Andrew Morton wrote:
> The code looks reasonable to me.  Unless others emit convincing
> squeaks, please ask Stephen to include your git tree into linux-next
> sometime within the next month, then send Linus a pull request for
> 2.6.33.

The code has seen 70 odd patches since then.  Mostly small fixes and 
cleanups, and a handful of larger changes.  Should these see the light of 
LKML before I send a pull request of Linus?  (So far they've just gone out 
to the ceph commit list.) I don't want to spam everyone with a huge series 
fixing up as yet unmerged code, but I'm not sure that review on the ceph 
lists is sufficient, given the frequency with which I see fs series on 
LKML...

What are the best practices here?

sage
