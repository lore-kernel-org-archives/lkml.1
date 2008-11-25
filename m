Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYKYVgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYKYVgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYKYVf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:35:58 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:53695 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbYKYVf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:35:57 -0500
Message-ID: <492C6F8E.5080207@oracle.com>
Date: Tue, 25 Nov 2008 13:35:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: mmotm 2008-11-24-16-52 uploaded (trace)
References: <200811250052.mAP0qxAQ005254@imap1.linux-foundation.org>
In-Reply-To: <200811250052.mAP0qxAQ005254@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.492C6F91.01D8:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2008-11-24-16-52 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

All of my i386 builds end with:

kernel/trace/ring_buffer.c:342: error: 'buffer' undeclared (first use in this function)
kernel/trace/ring_buffer.c:342: error: (Each ndeclared identifier is reported only once
kernel/trace/ring_buffer.c:342: error: for each function it appears in.)
make[3]: *** [kernel/trace/ring_buffer.o] Error 1

~Randy

