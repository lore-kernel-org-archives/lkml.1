Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbYBRHDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbYBRHDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 02:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYBRHC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 02:02:59 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49452 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752845AbYBRHC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 02:02:59 -0500
Date: Mon, 18 Feb 2008 01:02:54 -0600
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, menage@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH 1/7] cgroup: fix and update documentation
Message-Id: <20080218010255.a808714f.pj@sgi.com>
In-Reply-To: <47B91C75.6000907@cn.fujitsu.com>
References: <47B91C75.6000907@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>  *** notify_on_release is disabled in the current patch set. It will be
> -*** reactivated in a future patch in a less-intrusive manner
> +*** reactivated in a future patch in a less-intrusive manner.

Someone should verify this, but I'm pretty sure that notify_on_release
is now working ... no longer disabled.  I believe the above line from
the documentation is out of date.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
