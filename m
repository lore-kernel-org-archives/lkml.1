Return-Path: <linux-kernel-owner+w=401wt.eu-S971595AbXILSIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971595AbXILSIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765294AbXILSI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:08:28 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50101 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765162AbXILSI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:08:28 -0400
Date: Wed, 12 Sep 2007 20:08:27 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Chris Friesen <cfriesen@nortel.com>
cc: Jeff Garzik <jgarzik@pobox.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH/RFC] doc: about email clients for Linux kernel patches
In-Reply-To: <46E75C6A.3000705@nortel.com>
Message-ID: <Pine.LNX.4.64.0709122007530.22467@fbirervta.pbzchgretzou.qr>
References: <20070911101644.cd3f641f.randy.dunlap@oracle.com>
 <46E6EE96.9060309@nortel.com> <46E6F2A8.2020104@pobox.com> <46E75C6A.3000705@nortel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 11 2007 21:26, Chris Friesen wrote:
>> > Can someone describe the problems with just attaching the patch in
>> > Thunderbird?  It's what Martin says he does on the linked document...
>
>> Email clients don't like to quote attachments, even text/plain ones, which
>> then makes attached patches much more difficult to review and comment on
>> (i.e. you greatly reduce the number of reviewers).
>
> Thunderbird, at least, will automatically inline a single text/plain attachment
> when replying. (At least with my current settings, it does.)

No, the thing is: you send it attached with Thunderbird,
and my PINE strips it on reply _because_ it is an attachment.



	Jan
-- 
