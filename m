Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbYADHjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbYADHjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 02:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYADHjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 02:39:31 -0500
Received: from relay2.sgi.com ([192.48.171.30]:35188 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753109AbYADHja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 02:39:30 -0500
Date: Fri, 4 Jan 2008 01:39:26 -0600
From: Paul Jackson <pj@sgi.com>
To: Denis Cheng <crquan@gmail.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       emdow@us.ibm.com
Subject: Re: [PATCH] PROC_FS: get and set the smp affinity of tasks by
 read-write /proc/<pid>/smp_affinity
Message-Id: <20080104013926.b09e00b2.pj@sgi.com>
In-Reply-To: <1199430221-28417-1-git-send-email-crquan@gmail.com>
References: <1199430221-28417-1-git-send-email-crquan@gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you also update the file 'Documentation/filesystems/proc.txt' as
part of this patch?  It should document /proc/<pid>/* files.  Thanks.

(Don't tell anyone that this file doesn't mention /proc/<pid>/cpuset ;).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
