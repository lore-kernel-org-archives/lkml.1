Return-Path: <linux-kernel-owner+w=401wt.eu-S1030818AbXDLSxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030818AbXDLSxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 14:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030810AbXDLSxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 14:53:40 -0400
Received: from anchor-post-35.mail.demon.net ([194.217.242.85]:2232 "EHLO
	anchor-post-35.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030751AbXDLSxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 14:53:39 -0400
Message-ID: <461E802B.1040906@lougher.demon.co.uk>
Date: Thu, 12 Apr 2007 19:53:31 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Nate Diller <nate.diller@gmail.com>
CC: Andrew Morton <akpm@osdl.org>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 7/17] jffs2: convert jffs2_gc_fetch_page to read_cache_page
References: <20070412024938.27380.13619.patchbomb.py@localhost>	 <461E1AC9.30107@lougher.demon.co.uk> <5c49b0ed0704121129h51f852a1wbdc3192c89aec4e6@mail.gmail.com>
In-Reply-To: <5c49b0ed0704121129h51f852a1wbdc3192c89aec4e6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nate Diller wrote:

> 
> wow, you're right.  I was sure I compile-tested this ... oh, "depends
> on MTD".  oops.
> 
> thanks for reviewing.  does it look OK to you otherwise?
> 

Yes..

> NATE
> 

