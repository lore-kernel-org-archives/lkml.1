Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYEGAjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYEGAjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 20:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbYEGAjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 20:39:33 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36748 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752934AbYEGAjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 20:39:32 -0400
Date: Tue, 6 May 2008 19:39:31 -0500
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       lizf@cn.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
       kamezawa.hiroyu@jp.fujitsu.com, sivanich@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 125/311] Cpuset hardwall flag: switch cpusets to use the
 bulk cgroup_add_files() API
Message-Id: <20080506193931.3e009405.pj@sgi.com>
In-Reply-To: <6599ad830805061726n33f69552k756e8754387e4b8c@mail.gmail.com>
References: <200804290800.m3T80QFs009131@imap1.linux-foundation.org>
	<6599ad830804290329heea3c5fu7395b1ef71a87881@mail.gmail.com>
	<20080429053804.6d083a7f.akpm@linux-foundation.org>
	<20080506192018.26c1e3b7.pj@sgi.com>
	<6599ad830805061726n33f69552k756e8754387e4b8c@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> But I can send one against 2.6.26-rc1 directly if that helps.

At this point, whatever resolves this with the least amount of
additional effort and confusion on the parts of Linus, Andrew,
Seto-san and yourself seems best.  A few days one way or the
other don't matter, so far as I know.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
