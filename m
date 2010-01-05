Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891Ab0AEAvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0AEAvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421Ab0AEAvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:51:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054Ab0AEAvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:51:44 -0500
Subject: Re: [PATCH] sort: Introduce generic list_sort function
From: Dave Airlie <airlied@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
       Artem Bityutskiy <dedekind@infradead.org>,
       Adrian Hunter <adrian.hunter@nokia.com>
In-Reply-To: <1262649295-28427-1-git-send-email-david@fromorbit.com>
References: <1262649295-28427-1-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jan 2010 10:48:26 +1000
Message-Id: <1262652506.25818.5.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-05 at 10:54 +1100, Dave Chinner wrote:
> There are two copies of list_sort() in the tree already, one in the DRM code,
> another in ubifs. Now XFS needs this as well. Create a generic list_sort()
> function from the ubifs version and convert existing users to it so we
> don't end up with yet another copy in the tree.

Acked-by: Dave Airlie <airlied@redhat.com>

Meant to do this myself when we imported modesetting, but never got
around to it,

Thanks,
Dave.


