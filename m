Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbXJ2GLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbXJ2GLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 02:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXJ2GKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 02:10:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:27349 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbXJ2GKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 02:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EOWDleaoEtRLIQGC7s0VinadBydqui8a1InwhOfnwb93tMofI7K7iC+E3nDWTBQVGxpUSPvyB3NtfOVXmc42FKxi45N8rjKMRR18BCgo0U6IHcYTAT1diIh2JblM32bmGDT/fxClVDfFA+OMRmOG5Z5CNh2XdvijmVovNayrNsE=
Message-ID: <47257963.3070203@gmail.com>
Date: Mon, 29 Oct 2007 15:10:43 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeff Garrett <jeff@jgarrett.org>
CC: lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: western digital WD1500ADFD: spurious completions during NCQ
References: <1192651110.6103.61.camel@thog>
In-Reply-To: <1192651110.6103.61.camel@thog>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garrett wrote:
> Several threads that suggest this message is related to poor NCQ
> support, but I did not see any for this drive.  It's a Western Digital
> WD1500ADFD-00NLR1.  Is this the same thing, and should this drive be
> blacklisted?

How reproducible is the problem?

-- 
tejun
