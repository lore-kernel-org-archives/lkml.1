Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907Ab0AEGZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab0AEGZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 01:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217Ab0AEGY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 01:24:59 -0500
Received: from smtp.nokia.com ([192.100.122.230]:32373 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab0AEGY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 01:24:59 -0500
Subject: Re: [PATCH] sort: Introduce generic list_sort function
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@redhat.com>,
       Adrian Hunter <adrian.hunter@nokia.com>
In-Reply-To: <1262649295-28427-1-git-send-email-david@fromorbit.com>
References: <1262649295-28427-1-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jan 2010 08:23:58 +0200
Message-Id: <1262672638.4512.48.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Jan 2010 06:24:01.0712 (UTC) FILETIME=[AC033B00:01CA8DCF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-05 at 10:54 +1100, Dave Chinner wrote:
> There are two copies of list_sort() in the tree already, one in the DRM code,
> another in ubifs. Now XFS needs this as well. Create a generic list_sort()
> function from the ubifs version and convert existing users to it so we
> don't end up with yet another copy in the tree.
> 
> CC: Dave Airlie <airlied@redhat.com>
> CC: Artem Bityutskiy <dedekind@infradead.org>
> CC: Adrian Hunter <adrian.hunter@nokia.com>
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Acked-by: Artem Bityutskiy <dedekind@infradead.org>

Thanks, this has been in my TODO list for long time as well :-)

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

