Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbXKRKkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbXKRKkd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 05:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbXKRKkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 05:40:17 -0500
Received: from il.qumranet.com ([82.166.9.18]:46665 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbXKRKkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 05:40:15 -0500
Message-ID: <474016B0.6080204@qumranet.com>
Date: Sun, 18 Nov 2007 12:40:48 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: kvm-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [PATCH] - drivers/kvm/* - remove ptr comparisons
 to 0
References: <1194926811.9407.61.camel@localhost>
In-Reply-To: <1194926811.9407.61.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> fix sparse warnings "Using plain integer as NULL pointer"
>
>   

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

