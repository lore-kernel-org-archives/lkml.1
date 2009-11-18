Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbZKRVVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbZKRVVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbZKRVVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:21:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757286AbZKRVVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:21:24 -0500
Date: Wed, 18 Nov 2009 13:20:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wenji Huang <wenji.huang@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Kbuild: clean up marker
Message-Id: <20091118132053.87e817dc.akpm@linux-foundation.org>
In-Reply-To: <1258350595-19285-1-git-send-email-wenji.huang@oracle.com>
References: <1258350595-19285-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Nov 2009 13:49:54 +0800
Wenji Huang <wenji.huang@oracle.com> wrote:

> Drop Module.markers from cleaning list.

The changelog failed to explain the reason for this change.  Please
always include that vital information in changelogs.

I, for one, don't have a clue why you made this change.

