Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935641Ab0BZJGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:06:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55503 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935584Ab0BZJGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:06:17 -0500
Message-ID: <4B878F35.4020700@cn.fujitsu.com>
Date: Fri, 26 Feb 2010 17:07:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: containers@lists.linux-foundation.org, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: do not use dprintf in cgroup_event_listener
References: <1267093447-2607-1-git-send-email-kirill@shutemov.name>
In-Reply-To: <1267093447-2607-1-git-send-email-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote:
> glibc's dprintf(3) is buggy:
> http://sourceware.org/bugzilla/show_bug.cgi?id=11319
> 
> Let's not to use it in the example.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

