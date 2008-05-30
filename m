Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYE3P1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYE3P1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 11:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbYE3P0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 11:26:54 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42605 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752060AbYE3P0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 11:26:53 -0400
Date: Fri, 30 May 2008 10:26:51 -0500
From: Paul Jackson <pj@sgi.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: miaox@cn.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [PATCH 1/3] cpusets: cleanup kernel-doc
Message-Id: <20080530102651.b99687dd.pj@sgi.com>
In-Reply-To: <20080530105018.71dac558@core>
References: <483FAD74.5040702@cn.fujitsu.com>
	<20080530105018.71dac558@core>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> These are not redundant

Miao wasn't saying the kernel-doc '/**' markers were redundant.

He was saying that, in one case, there was a redundant
blank line, right in the middle of a kernel-doc comment,
that broke that particular kernel-doc formatting.

That one-line fix is still worth getting in, though
probably not worth a patch all by itself.

The NAK by Alan of the rest of this patch still applies.

Thanks, Alan, Randy and Miao.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
