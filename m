Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbYG1EZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbYG1EZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 00:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYG1EZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 00:25:07 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34807 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750922AbYG1EZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 00:25:06 -0400
Date: Sun, 27 Jul 2008 23:25:02 -0500
From: Paul Jackson <pj@sgi.com>
To: akpm@linux-foundation.org, Cliff Wickman <cpw@sgi.com>
Cc: menage@google.com, linux-kernel@vger.kernel.org,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cpuset: a bit cleanup for scan_for_empty_cpusets()
Message-Id: <20080727232502.0613c7ca.pj@sgi.com>
In-Reply-To: <488D3325.8030203@cn.fujitsu.com>
References: <488D3325.8030203@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew - could you add the following CC to this patch:

	Cc: Cliff Wickman <cpw@sgi.com>

Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
