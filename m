Return-Path: <linux-kernel-owner+w=401wt.eu-S1761577AbXGCQt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577AbXGCQt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761425AbXGCQrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:47:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:64335 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761327AbXGCQrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:47:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Wi5o7PILGxpThpL8nERhdvCcFmL7Orjv2S1Hea7QxYPk2AjfLJAaTRBjcu41HrhKfkd/A2P6//na+rQAmgey3n12pOXcOTCVS7jOtS6Ck18Yl9bCAiOYzs2OGOwP+s6Rv2es4mxp391kvoDpPlhyDdi1yIWzuH8cUmuuZpgV9kY=
Date: Tue, 3 Jul 2007 18:47:10 +0200
From: Florian Attenberger <valdyn@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: any known issues with leap seconds in 2.6.10?
Message-ID: <20070703164710.GA18585@master.home>
References: <468A7145.7030606@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <468A7145.7030606@nortel.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 11:54:45AM -0400, Chris Friesen wrote:
>
> I'm just wondering if anyone knows of issues with leap second handling in 
> 2.6.10.  We just had a field incident where a couple of quad-x86 machines 
> went down at just before midnight (UTC) on June 30th...which is when leap 
> seconds would normally be applied.
>
> From our logs it looks like something went crazy while holding the xtime 
> lock.
>
> If anyone knows of issues with that code I'd love to hear about it.
>
> Thanks,
>
> Chris
look at the thread  '2.6.21.5 june 30th to july 1st date hang'

