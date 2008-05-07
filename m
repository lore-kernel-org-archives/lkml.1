Return-Path: <linux-kernel-owner+w=401wt.eu-S1760285AbYEGCRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbYEGCRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 22:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbYEGCRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 22:17:05 -0400
Received: from relay2.sgi.com ([192.48.171.30]:40210 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755301AbYEGCRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 22:17:03 -0400
Date: Tue, 6 May 2008 21:17:00 -0500
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: menage@google.com, akpm@linux-foundation.org,
       seto.hidetoshi@jp.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
Message-Id: <20080506211700.c9707275.pj@sgi.com>
In-Reply-To: <48210FFC.4080403@cn.fujitsu.com>
References: <48210101.1070205@google.com>
	<20080506183841.e1771032.akpm@linux-foundation.org>
	<482109E5.5050204@cn.fujitsu.com>
	<20080506204946.7754302d.pj@sgi.com>
	<6599ad830805061851n767ff7a1qc8cb850ec98ad60d@mail.gmail.com>
	<20080506205852.8adaa0a2.pj@sgi.com>
	<48210FFC.4080403@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> I prefer to put a limit on it, but as Andrew just said, we don't
> need to rush for this. But sure I'll post a patch if Seto-san
> doesn't have an objection on this.

Good - I agree on all points.  Thank-you.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
