Return-Path: <linux-kernel-owner+w=401wt.eu-S932535AbYGQWaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbYGQWaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759899AbYGQWaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:30:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759890AbYGQW37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:29:59 -0400
Date: Thu, 17 Jul 2008 15:28:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: wenji.huang@oracle.com, roland@redhat.com, t-nishiie@np.css.fujitsu.com,
       ltt-dev@lists.casi.polymtl.ca, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix markers duplicate modpost entry (update)
Message-Id: <20080717152837.8982fe8a.akpm@linux-foundation.org>
In-Reply-To: <20080717145217.GA24496@Krystal>
References: <20080715024754.GA26471@Krystal>
	<000001c8e7aa$b9548600$2bfd9200$@css.fujitsu.com>
	<20080717024550.GA22869@Krystal>
	<487ED503.2060503@oracle.com>
	<20080717070321.GB26035@Krystal>
	<20080717001613.8fe204df.akpm@linux-foundation.org>
	<20080717145217.GA24496@Krystal>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 10:52:17 -0400
Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> Subject: Re: [PATCH] Fix markers duplicate modpost entry (update)

Please prepare the patch titles along the lines of

	[patch] subsystem-identifer: what i did to it

so this one would have been

	[patch] markers: fix markers duplicate modpost entry


It's for consistency, and for ease of reading commits mailing lists and
gitk titles and git-shortlog output, etc.

Thanks.
