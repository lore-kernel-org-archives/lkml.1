Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbZDRQVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbZDRQVj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 12:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756928AbZDRQVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 12:21:31 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:7931 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893AbZDRQVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 12:21:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tFvbyHW7aVHSgRN/Jx7H5OWk50wPxTjnYclPXIYeFdc1oVCY+dwKk612xBFCrcrQjO
         dAtGIAw1/v4eopLOl31TrhcmRdkON9J4xV9Ap+feSmZc8+LklzwAjSkPLtxnPzWCOwch
         fqAncwojZ7tVB+P5akv/Jx2mCqvaHvtHq1EDw=
MIME-Version: 1.0
In-Reply-To: <1239953416.3390.243.camel@localhost.localdomain>
References: <a95a62fe0904082252h41afa872j2ef6fb9d1d76dc27@mail.gmail.com>
	 <1239953416.3390.243.camel@localhost.localdomain>
Date: Sat, 18 Apr 2009 09:21:28 -0700
Message-ID: <a95a62fe0904180921w3ac0128et7a543742f5734d64@mail.gmail.com>
Subject: Re: [PATCH 2/4] [MTD] Add MEMERASE64 ioctl for >4GiB devices
From: Kevin Cernekee <kpc.mtd@gmail.com>
To: dedekind@infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux MTD <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 12:30 AM, Artem Bityutskiy
<dedekind@infradead.org> wrote:
> Kevin, are you going to re-send patches 2-4, taking into account
> Arnd's and Andrew's suggestions?

For Arnd's suggestion, I posted a followup patch here:

http://lists.infradead.org/pipermail/linux-mtd/2009-April/025269.html

Andrew brought up two issues: [MTD] in the subject line, and
linewrapping.  I am assuming that he fixed these himself since he
pulled all five patches (originals + followup) into the -mm tree.

Should I fix and repost the set anyway?

Thanks.
