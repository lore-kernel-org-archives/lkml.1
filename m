Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbYEGBBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbYEGBBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYEGBAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:00:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753337AbYEGBAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:00:49 -0400
Date: Tue, 6 May 2008 18:00:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
Cc: menage@google.com, torvalds@linux-foundation.org, lizf@cn.fujitsu.com,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
       Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 125/311] Cpuset hardwall flag: switch cpusets to use the
 bulk cgroup_add_files() API
Message-Id: <20080506180006.107b2dcd.akpm@linux-foundation.org>
In-Reply-To: <20080506192018.26c1e3b7.pj@sgi.com>
References: <200804290800.m3T80QFs009131@imap1.linux-foundation.org>
	<6599ad830804290329heea3c5fu7395b1ef71a87881@mail.gmail.com>
	<20080429053804.6d083a7f.akpm@linux-foundation.org>
	<20080506192018.26c1e3b7.pj@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 19:20:18 -0500 Paul Jackson <pj@sgi.com> wrote:

>  1) I can't get 2.6.25-rc1-mm1-mmotm to apply even close to
>     either of 2.6.25 or 2.6.25-rc1.  Blows up on the first
>     patch.

origin.patch?  That shouldn't happen.

> 	==> akpm - what does todays 2.6.25-rc1-mm1-mmotm
> 	    apply to?

2.6.25-rc1.

<resyncs>

It _should_ be OK.  Please check?

