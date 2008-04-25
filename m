Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbYDYH65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbYDYH65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbYDYH6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:58:49 -0400
Received: from atlanta.zankel.net ([69.61.78.146]:1292 "EHLO
	atlanta.zankel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325AbYDYH6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:58:48 -0400
Message-ID: <48118F35.3030102@zankel.net>
Date: Fri, 25 Apr 2008 00:58:45 -0700
From: Christian Zankel <chris@zankel.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] xtensa: don't offer ATA
References: <20080414195521.GB26885@cs181133002.pp.htv.fi> <4807A771.2020405@pobox.com> <20080421193927.GA2633@cs181133002.pp.htv.fi>
In-Reply-To: <20080421193927.GA2633@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

Adrian Bunk wrote:
>> XTENSA offers HAS_IOMEM but not iomem functions?  That seems like the  
>> problem to me.
> 
> Chris, can you comment on this?

Yes, the iomem functions are missing. I finally have a board that allows 
me to test io functionality. I don't just want to add the functions 
without having the chance to test them.

-Chris
