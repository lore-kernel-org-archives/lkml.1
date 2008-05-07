Return-Path: <linux-kernel-owner+w=401wt.eu-S934364AbYEGXH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934364AbYEGXH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 19:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934179AbYEGXGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 19:06:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41124 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933911AbYEGXGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 19:06:33 -0400
Date: Wed, 7 May 2008 18:06:32 -0500
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adobriyan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Fix cpumask_scnprintf_len() misdesign
Message-Id: <20080507180632.3f5cbf0d.pj@sgi.com>
In-Reply-To: <20080507143537.94d744c5.akpm@linux-foundation.org>
References: <20080507221450.GA14375@martell.zuzino.mipt.ru>
	<20080507143537.94d744c5.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew asked:
> Does Paul have an opinion?

Of course ;).

I just sent a patch to remove bitmap_scnprintf_len and cpumask_scnprintf_len.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
