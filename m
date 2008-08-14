Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbYHNTSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbYHNTSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYHNTS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:18:29 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55339 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbYHNTS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:18:29 -0400
Message-ID: <48A4844E.5090404@cs.helsinki.fi>
Date: Thu, 14 Aug 2008 22:15:26 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: eduard.munteanu@linux360.ro, sfr <sfr@canb.auug.org.au>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] kmemtrace: fix printk format warnings
References: <20080813105114.a21a44de.randy.dunlap@oracle.com>
In-Reply-To: <20080813105114.a21a44de.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warnings:
> 
> linux-next-20080813/include/linux/kmemtrace.h:33: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'size_t'
> linux-next-20080813/include/linux/kmemtrace.h:33: warning: format '%lu' expects type 'long unsigned int', but argument 6 has type 'size_t'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks!
