Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbYCTQQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbYCTQQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 12:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbYCTQQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 12:16:19 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:34468 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbYCTQQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 12:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lmAVn0mZe/703cb1zP3GX51YvuRnUKqWYIsaTgBhbvPnm4m4Tzd3TZarBXidRZmDyZ8IxByDUfuz+cAxdrgZ4aeSrjcd1VqMRPPpfNqHYtTwLS0zs6AjMQPrROcXYrkVImgBy57/y1tzdWv++wm8baONT7jpc2rqZP30+2v7Vyc=
Subject: Re: many items in Documentation/feature-removal-schedule.txt have
	expired, please update
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: rae l <crquan@gmail.com>, Pavel Machek <pavel@suse.cz>,
       David Miller <davem@davemloft.net>, Dominik Brodowski <linux@brodo.de>,
       Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@linux.intel.com>,
       Nick Piggin <npiggin@suse.de>, Len Brown <len.brown@intel.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <20080320132543.GA11149@lst.de>
References: <91b13c310803200622k6a302851nc97774615f2ef3ee@mail.gmail.com>
	 <20080320132543.GA11149@lst.de>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 09:15:52 -0700
Message-Id: <1206029752.17059.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-20 at 14:25 +0100, Christoph Hellwig wrote:
> On Thu, Mar 20, 2008 at 09:22:29PM +0800, rae l wrote:
> > What:	old NCR53C9x driver
> > When:	October 2007
> > Why:	Replaced by the much better esp_scsi driver.  Actual low-level
> > 	driver can be ported over almost trivially.
> > Who:	David Miller <davem@davemloft.net>
> > 	Christoph Hellwig <hch@lst.de>
> 
> This one is long gone, probably just needs a doc patch.
> 

I sent a patch to James Bottomley after the removal a few weeks ago, he
said he wanted the message to stay for a release in case someone goes
looking for the driver.

Harvey


