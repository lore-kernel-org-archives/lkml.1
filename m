Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbZEFBCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbZEFBCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 21:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbZEFBC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 21:02:26 -0400
Received: from tundra.namei.org ([65.99.196.166]:60377 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbZEFBCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 21:02:25 -0400
Date: Wed, 6 May 2009 11:02:25 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, david safford <safford@watson.ibm.com>
Subject: Re: [PATCH] integrity: remove __setup auditing msgs
In-Reply-To: <1241543590.6101.12.camel@dyn9002018117.watson.ibm.com>
Message-ID: <alpine.LRH.2.00.0905061102080.11402@tundra.namei.org>
References: <1241543590.6101.12.camel@dyn9002018117.watson.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009, Mimi Zohar wrote:

> Remove integrity audit messages from __setup()
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

All applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
