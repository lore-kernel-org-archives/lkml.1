Return-Path: <linux-kernel-owner+w=401wt.eu-S1763352AbYEGUVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763352AbYEGUVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYEGUVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:21:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708AbYEGUVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:21:05 -0400
Date: Wed, 7 May 2008 13:21:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: gentle reminder
Message-Id: <20080507132103.574f8778.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


<comes back from fixing more rejects>

When adding

- new Makefile entries
- new Kconfig entries
- new #includes
- new Documentation/feature-removal-schedule.txt records
- etc

you usually don't *have* to place your new entry right at the end of the
list.  Doing this maximises the probability of causing collisions with
other people's work.

So, to make life simpler for those who integrate your work, please consider
putting these entries somewhere other than where-everyone-else-puts-theirs.

You may even find that right-at-the-end wasn't the most appropriate place
anyway.  But random insertion works well too.

Thanks.

