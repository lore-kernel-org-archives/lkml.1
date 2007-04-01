Return-Path: <linux-kernel-owner+w=401wt.eu-S1752256AbXDAU2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbXDAU2K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 16:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbXDAU2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 16:28:10 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:47781 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbXDAU2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 16:28:09 -0400
Date: Sun, 01 Apr 2007 14:27:51 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Fwd: kswapd issues + kernel 2.4.21-32.0.1.ELsmp
In-reply-to: <fa.Fyq10Ks5ejO6P+77Y8svOle1kro@ifi.uio.no>
To: Pedram M <pmessri@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <461015C7.60804@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.vikcLJfO/FKczN77bSVCqEtBhL0@ifi.uio.no>
 <fa.Fyq10Ks5ejO6P+77Y8svOle1kro@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pedram M wrote:
> Hi,
> 
> I've seen this around, and have heard about it in forums and else-where,
> could somebody enlighten me with more information or with experiences
> they have had.  Looks like kswapd begins to eat CPU dramatically till the
> box eventually locks up.
> 
> Thanks,
> Pedram

Looks like an old RHEL3 kernel - first off try the latest updated kernel 
which is 2.4.21-47.0.1.EL.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

