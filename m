Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbXK0VFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbXK0VFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 16:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbXK0VF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 16:05:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbXK0VF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:05:26 -0500
Message-ID: <474C8691.6020405@redhat.com>
Date: Tue, 27 Nov 2007 15:05:21 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       mbligh@mbligh.org, val.henson@intel.com
Subject: Re: [PATCH] fix up ext2_fs.h for userspace after reservations backport
References: <474B003D.7040908@redhat.com> <20071127125509.7cda1328.akpm@linux-foundation.org>
In-Reply-To: <20071127125509.7cda1328.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> I did this instead:

(moved offending function from ext2_fs.h to ext2.h)

Look like a better plan, thanks.

-Eric

