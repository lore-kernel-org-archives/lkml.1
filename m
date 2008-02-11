Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYBKPje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYBKPje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757434AbYBKPjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:39:12 -0500
Received: from mga06.intel.com ([134.134.136.21]:33737 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757996AbYBKPjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:39:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,333,1199692800"; 
   d="scan'208";a="338102188"
Message-ID: <47B06AD1.6090504@linux.intel.com>
Date: Mon, 11 Feb 2008 07:33:37 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@sw.ru>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] proc: print more information when removing non-empty
 directories
References: <20080211113037.GC6110@localhost.sw.ru>
In-Reply-To: <20080211113037.GC6110@localhost.sw.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> This usually saves one recompile to insert similar printk like below. :)
> 
> Sample nastygram:


looks very useful to me!
