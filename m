Return-Path: <linux-kernel-owner+w=401wt.eu-S934783AbXGRRzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934783AbXGRRzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760302AbXGRRzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:55:11 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50725 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644AbXGRRzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:55:09 -0400
Date: Wed, 18 Jul 2007 19:55:08 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.22-git* regression: Kconfig prompts without help text
In-Reply-To: <20070718103456.cf32bf78.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0707181954190.5385@fbirervta.pbzchgretzou.qr>
References: <469BBDAD.2010908@s5r6.in-berlin.de>
 <Pine.LNX.4.64.0707181634100.5385@fbirervta.pbzchgretzou.qr>
 <20070718094119.4a26ae03.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0707181916410.5385@fbirervta.pbzchgretzou.qr>
 <20070718103456.cf32bf78.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 18 2007 10:34, Randy Dunlap wrote:
>> On Jul 18 2007 09:41, Randy Dunlap wrote:
>> >
>> >Looks good to me except that help text should be indented by
>> >2 more spaces according to CodingStyle.
>> 
>> Who invented that rule anyway... the "---help---" marker (note the dashes)
>> clearly separates things already.
>> Here you go.
>
>I have no idea where it came from.  (not me)

It was akpm:
http://linux.bkbits.net:8080/linux-2.6/Documentation/CodingStyle?PAGE=diffs&REV=1.5

Well, can we lift it?


Thanks,
	Jan
-- 
