Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbYEGBVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbYEGBVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYEGBVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:21:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:59822 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbYEGBVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:21:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=kz18NG0snmwp7j6WKWVXLUOzqzX7DGAza9FKC8Bi3eKDYxWFs25WLTcCMVQpBV6qv
	lSK+wPCJG5Tb+Q5L1P0/Q==
Message-ID: <6599ad830805061821k3aa71e6eyc6ce6330c2162c43@mail.gmail.com>
Date: Tue, 6 May 2008 18:21:29 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch 125/311] Cpuset hardwall flag: switch cpusets to use the bulk cgroup_add_files() API
Cc: "Paul Jackson" <pj@sgi.com>, torvalds@linux-foundation.org,
       lizf@cn.fujitsu.com, "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Hiroyuki KAMEZAWA" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Dimitri Sivanich" <sivanich@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080506180326.f2f69dea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804290800.m3T80QFs009131@imap1.linux-foundation.org>
	 <6599ad830804290329heea3c5fu7395b1ef71a87881@mail.gmail.com>
	 <20080429053804.6d083a7f.akpm@linux-foundation.org>
	 <20080506192018.26c1e3b7.pj@sgi.com>
	 <6599ad830805061726n33f69552k756e8754387e4b8c@mail.gmail.com>
	 <20080506180326.f2f69dea.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2008 at 6:03 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>  > Not yet - I was waiting for 2.6.26-rc1-mm1 to come out. But I can send
>  > one against 2.6.26-rc1 directly if that helps.
>
>  I'm still crunching on backlog.  A fix against mainline would be great,
>  thanks.
>

Sent.

Paul
