Return-Path: <linux-kernel-owner+w=401wt.eu-S932883AbYBCH6C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbYBCH6C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 02:58:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936052AbYBCH5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 02:57:52 -0500
Received: from relay1.sgi.com ([192.48.171.29]:53984 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759499AbYBCH5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 02:57:51 -0500
Date: Sun, 3 Feb 2008 01:57:49 -0600
From: Paul Jackson <pj@sgi.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: sparse warnings in cpuset.c
Message-Id: <20080203015749.1cbf2b83.pj@sgi.com>
In-Reply-To: <1202024543.1844.57.camel@brick>
References: <1202019619.1844.52.camel@brick>
	<20080203012815.05a50b13.pj@sgi.com>
	<1202024543.1844.57.camel@brick>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey wrote:
> Don't redeclare p, use a new variable q.

You dah man!  Thanks.

Acked-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
