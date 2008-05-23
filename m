Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbYEWOZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbYEWOZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYEWOZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:25:28 -0400
Received: from relay1.sgi.com ([192.48.171.29]:60596 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753701AbYEWOZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:25:27 -0400
Date: Fri, 23 May 2008 09:25:27 -0500
From: Paul Jackson <pj@sgi.com>
To: miaox@cn.fujitsu.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [PATCH] cpusets: fix and update Documentation
Message-Id: <20080523092527.6b56433f.pj@sgi.com>
In-Reply-To: <483674AA.4090504@cn.fujitsu.com>
References: <483674AA.4090504@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miao wrote:
> Make the doc consistent with current cpusets implementation.

Good fixes - thanks.

Acked-by: Paul Jackson <pj@sgi.com>

> - - It can only be marked exclusive if its parent is.
> + - It can't be marked exclusive unless its parent is.

I read both versions of this sentence as meaning the same thing,
though I think your new version is easier to read - good.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
