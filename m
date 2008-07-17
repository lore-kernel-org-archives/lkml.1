Return-Path: <linux-kernel-owner+w=401wt.eu-S1761172AbYGQWm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761172AbYGQWm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbYGQWms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:42:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:25181 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbYGQWmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:42:47 -0400
Date: Thu, 17 Jul 2008 15:40:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>, wenji.huang@oracle.com,
       roland@redhat.com, t-nishiie@np.css.fujitsu.com,
       ltt-dev@lists.casi.polymtl.ca, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix markers duplicate modpost entry (update)
Message-Id: <20080717154011.7677adf6.randy.dunlap@oracle.com>
In-Reply-To: <20080717152837.8982fe8a.akpm@linux-foundation.org>
References: <20080715024754.GA26471@Krystal>
	<000001c8e7aa$b9548600$2bfd9200$@css.fujitsu.com>
	<20080717024550.GA22869@Krystal>
	<487ED503.2060503@oracle.com>
	<20080717070321.GB26035@Krystal>
	<20080717001613.8fe204df.akpm@linux-foundation.org>
	<20080717145217.GA24496@Krystal>
	<20080717152837.8982fe8a.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 15:28:37 -0700 Andrew Morton wrote:

> On Thu, 17 Jul 2008 10:52:17 -0400
> Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> 
> > Subject: Re: [PATCH] Fix markers duplicate modpost entry (update)
> 
> Please prepare the patch titles along the lines of
> 
> 	[patch] subsystem-identifer: what i did to it
> 
> so this one would have been
> 
> 	[patch] markers: fix markers duplicate modpost entry
> 
> 
> It's for consistency, and for ease of reading commits mailing lists and
> gitk titles and git-shortlog output, etc.

Agreed, although I would have used

	[PATCH] modpost: fix duplicate markers entries


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
