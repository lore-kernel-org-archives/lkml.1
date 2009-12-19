Return-Path: <linux-kernel-owner+w=401wt.eu-S1752120AbZLSM2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbZLSM2r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 07:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbZLSM2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 07:28:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40043 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZLSM2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 07:28:46 -0500
X-Authority-Analysis: v=1.0 c=1 a=vB0P8UTOP5sA:10 a=7U3hwN5JcxgA:10 a=yPCof4ZbAAAA:8 a=meVymXHHAAAA:8 a=QyMqLM8RQBULtshC-2MA:9 a=fdpZlQVHmXNIuOhxvxCQHrY35UUA:4 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 4/4] Documentation: update ring-buffer-design.txt
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
In-Reply-To: <4B2C0D7E.5030602@oracle.com>
References: <4B2C0D7E.5030602@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sat, 19 Dec 2009 07:28:43 -0500
Message-ID: <1261225723.2146.881.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 15:17 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix typos, grammos, spellos, hyphenation.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  Documentation/trace/ring-buffer-design.txt |   56 ++++++++++++++---------------
>  1 file changed, 28 insertions(+), 28 deletions(-)
> 
> --- lnx-2633-rc1.orig/Documentation/trace/ring-buffer-design.txt
> +++ lnx-2633-rc1/Documentation/trace/ring-buffer-design.txt
> @@ -33,9 +33,9 @@ head_page - a pointer to the page that t
>  

Acked-by: Steven Rostedt <rostedt@goodmis.org>

Thanks Randy!

-- Steve


