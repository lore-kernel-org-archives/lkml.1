Return-Path: <linux-kernel-owner+w=401wt.eu-S1752737AbYKGWig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbYKGWig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 17:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYKGWi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 17:38:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171AbYKGWi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 17:38:28 -0500
Date: Fri, 7 Nov 2008 14:38:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] DOC: add printk-formats.txt
Message-Id: <20081107143822.abb05629.akpm@linux-foundation.org>
In-Reply-To: <20081107135132.a6fe9bba.randy.dunlap@oracle.com>
References: <20081107135132.a6fe9bba.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008 13:51:32 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Add printk-formats.txt so that we don't have to keep fixing the
> same things over and over again.  <wishful thinking>
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Alexey Dobriyan <adobriyan@gmail.com>
> ---
>  Documentation/00-INDEX           |    2 ++
>  Documentation/printk-formats.txt |   36 ++++++++++++++++++++++++++++++++++++

cat Documentation/printk-formats.txt Documentation/SubmitChecklist > .signature ?
