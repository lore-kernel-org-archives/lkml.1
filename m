Return-Path: <linux-kernel-owner+w=401wt.eu-S1763655AbYEPAGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763655AbYEPAGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 20:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbYEPAFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 20:05:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755934AbYEPAFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 20:05:52 -0400
Date: Thu, 15 May 2008 17:05:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: harvey.harrison@gmail.com, david-b@pacbell.net, greg@kroah.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       cooloney@kernel.org, jie.zhang@analog.com
Subject: Re: [PATCH 1/1] [usb/host]: use get/put_unaligned_* helpers to fix
 more potential unaligned issues.
Message-Id: <20080515170530.a65dfc8a.akpm@linux-foundation.org>
In-Reply-To: <1210832364-20012-1-git-send-email-cooloney@kernel.org>
References: <1210832364-20012-1-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 14:19:24 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> Subject: [PATCH 1/1] [usb/host]: use get/put_unaligned_* helpers to fix more potential unaligned issues.

Please don't put the subsystem identifier ("usb/host") inside square
brackets.  Because text in square brackets is considered "not part of
the patch title" and gets thrown away.  It contains text such as
"patch", "BUG", "RFC", "2.6.26-rc2", etc.

That should be in Documentation/SubmittingPatches but I can't find it. hrm.
