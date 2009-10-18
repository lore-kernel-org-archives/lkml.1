Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbZJRTZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbZJRTZZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 15:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZJRTZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 15:25:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:36316 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbZJRTZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 15:25:24 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs / Novell
To: Eric Paris <eparis@redhat.com>
Subject: Re: [BUGFIX] dnotify: handle_event shouldn't match on FS_EVENT_ON_CHILD
Date: Sun, 18 Oct 2009 21:22:27 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200910181446.44625.agruen@suse.de> <1255881130.15182.99.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1255881130.15182.99.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910182122.28903.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 October 2009 17:52:10 Eric Paris wrote:
> Added to my linus tree last night (along with a couple other fixes) will
> push it public and ask him to pull when I finish testing.

Thanks.

Andreas
