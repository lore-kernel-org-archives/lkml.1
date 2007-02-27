Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbXB0RnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbXB0RnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 12:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbXB0RnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 12:43:07 -0500
Received: from terminus.zytor.com ([192.83.249.54]:47762 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbXB0RnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 12:43:06 -0500
Message-ID: <45E46D8E.7090108@zytor.com>
Date: Tue, 27 Feb 2007 09:42:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Kyle McMartin <kyle@parisc-linux.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: resource_size_t printk whinging
References: <20070227041648.GB13669@athena.road.mcmartin.ca>
In-Reply-To: <20070227041648.GB13669@athena.road.mcmartin.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> 
> (Or perhaps gcc can be extended such that a string of allowable qualifiers
>  can be passed along in kernel.h, that would just be super...)
> 

That would of course be the best.  Something like an 
"format_custom_size("r", resource_t)" attribute.

	-hpa
