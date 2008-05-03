Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbYECCcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbYECCcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 22:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbYECCck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 22:32:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234AbYECCcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 22:32:39 -0400
Date: Fri, 2 May 2008 19:31:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       linux-kernel@vger.kernel.org, joern@lazybastard.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] fix checkstack.pl arch detection
Message-Id: <20080502193128.5e1de100.akpm@linux-foundation.org>
In-Reply-To: <481BCC00.1030508@redhat.com>
References: <481B4D75.9060305@redhat.com>
	<20080502223702.GI24080@logfs.org>
	<20080502164458.b703acf7.akpm@linux-foundation.org>
	<481BCC00.1030508@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 May 2008 21:20:48 -0500 Eric Sandeen <sandeen@redhat.com> wrote:

> Andrew Morton wrote:
> > On Sat, 3 May 2008 00:37:03 +0200
> > J__rn Engel <joern@logfs.org> wrote:
> > 
> >> On Fri, 2 May 2008 12:20:53 -0500, Eric Sandeen wrote:
> >>> uname -m was leaving a newline in $arch, and not passing the tests.
> >>>
> >>> Also, printing the unknown arch on failure is probably helpful.
> >>>
> >>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> Reviewed-By: Joern Engel <joern@logfs.org>
> >>
> > 
> > please cc apw on checkpatch changes.
> > 
> > This patch needs some help to merge against the forthcoming
> > checkpatch-0.19.  I sent your patches apw-wards.
> > 
> 
> Um, checkpatch or checkstack? :)
> 

bah.

hm, I wonder why one of them got a reject.  `patch -l' was needed.  Mailer
munchies, perhaps?

Please check that what I applied is still correct.

