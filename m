Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbYFBJz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbYFBJz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757895AbYFBJzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:55:48 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58461 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757671AbYFBJzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:55:47 -0400
Date: Mon, 2 Jun 2008 04:55:45 -0500
From: Paul Jackson <pj@sgi.com>
To: miaox@cn.fujitsu.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [PATCH 1/2] cpusets: restructure the function update_cpumask()
 and update_nodemask()
Message-Id: <20080602045545.4fca93a1.pj@sgi.com>
In-Reply-To: <4843AFC9.7000100@cn.fujitsu.com>
References: <4843AFC9.7000100@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good work, Miao.

Andrew - these two patches of Miao should be ready for you to consider now.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
