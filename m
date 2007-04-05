Return-Path: <linux-kernel-owner+w=401wt.eu-S1945922AbXDEGWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945922AbXDEGWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 02:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945941AbXDEGWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 02:22:00 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51914 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945922AbXDEGV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 02:21:59 -0400
Message-ID: <46149576.9080401@zytor.com>
Date: Wed, 04 Apr 2007 23:21:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] doc/kernel-parameters: use IA-32 tag instead of i386
References: <20070404220534.36cd24e9.randy.dunlap@oracle.com>
In-Reply-To: <20070404220534.36cd24e9.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Use documented tag for "IA-32" (not "i386") to indicate which
> kernel parameters apply to IA-32.
> 

We call this architecture "i386" everywhere else.  I think it makes more 
sense to change the documented tag to "i386", especially with Intel 
sometimes calling x86-64 "IA-32e".

	-hpa
