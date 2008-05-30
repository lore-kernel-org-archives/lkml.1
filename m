Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbYE3HnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbYE3HnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 03:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYE3HnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 03:43:08 -0400
Received: from relay1.sgi.com ([192.48.171.29]:41757 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750726AbYE3HnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 03:43:07 -0400
Date: Fri, 30 May 2008 02:43:02 -0500
From: Paul Jackson <pj@sgi.com>
To: miaox@cn.fujitsu.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [PATCH 1/3] cpusets: cleanup kernel-doc
Message-Id: <20080530024302.15820964.pj@sgi.com>
In-Reply-To: <483FAD74.5040702@cn.fujitsu.com>
References: <483FAD74.5040702@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miao wrote:
> 1. Use '/*' instead of '/**' for static functions.
> 2. Remove redundant blank line.

Acked-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
