Return-Path: <linux-kernel-owner+w=401wt.eu-S937667AbYEBXqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937667AbYEBXqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933229AbYEBXqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:46:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933100AbYEBXqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:46:19 -0400
Date: Fri, 2 May 2008 16:44:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: sandeen@redhat.com, linux-kernel@vger.kernel.org, joern@lazybastard.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] fix checkstack.pl arch detection
Message-Id: <20080502164458.b703acf7.akpm@linux-foundation.org>
In-Reply-To: <20080502223702.GI24080@logfs.org>
References: <481B4D75.9060305@redhat.com>
	<20080502223702.GI24080@logfs.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008 00:37:03 +0200
J__rn Engel <joern@logfs.org> wrote:

> On Fri, 2 May 2008 12:20:53 -0500, Eric Sandeen wrote:
> > 
> > uname -m was leaving a newline in $arch, and not passing the tests.
> > 
> > Also, printing the unknown arch on failure is probably helpful.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-By: Joern Engel <joern@logfs.org>
> 

please cc apw on checkpatch changes.

This patch needs some help to merge against the forthcoming
checkpatch-0.19.  I sent your patches apw-wards.

