Return-Path: <linux-kernel-owner+w=401wt.eu-S1759145AbYEGC2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbYEGC2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 22:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755109AbYEGC2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 22:28:14 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39876 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbYEGC2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 22:28:14 -0400
Message-ID: <48211381.50500@jp.fujitsu.com>
Date: Wed, 07 May 2008 11:27:13 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>,
       akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
References: <48210101.1070205@google.com>	<20080506183841.e1771032.akpm@linux-foundation.org>	<482109E5.5050204@cn.fujitsu.com>	<20080506204946.7754302d.pj@sgi.com>	<6599ad830805061851n767ff7a1qc8cb850ec98ad60d@mail.gmail.com> <20080506205852.8adaa0a2.pj@sgi.com> <48210FFC.4080403@cn.fujitsu.com>
In-Reply-To: <48210FFC.4080403@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I apologize for the confusion...

Li Zefan wrote:
> I prefer to put a limit on it, but as Andrew just said, we don't
> need to rush for this. But sure I'll post a patch if Seto-san
> doesn't have an objection on this.

I don't have any.

Thanks,
H.Seto
