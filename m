Return-Path: <linux-kernel-owner+w=401wt.eu-S934287AbYEVIjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287AbYEVIjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYEVIjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:39:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58434 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751857AbYEVIjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:39:06 -0400
Date: Thu, 22 May 2008 03:39:06 -0500
From: Paul Jackson <pj@sgi.com>
To: Paul Menage <menage@google.com>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] remove unnecessary memmove() in cgroup_path()
Message-Id: <20080522033906.742aacb1.pj@sgi.com>
In-Reply-To: <48352127.20804@cn.fujitsu.com>
References: <48352127.20804@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage -- since you are the MAINTAINER of kernel/cgroup.c,
I should have CC'd you on my responses to this patch, sent out
earlier this evening.  My apologies for not doing so.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
