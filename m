Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbYCFF4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbYCFF4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 00:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbYCFF4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 00:56:41 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:8106 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbYCFF4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 00:56:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=kdXQnoYQwBVAX+vY4Sg8VXXEQelu7lje/2sDKSQ5qJYX/FXo0rmvU3GYVJE6tihegi4giUS+AkyGDmwM2Neqt49gOFD8LWyqq/lV6Vfm4fyzKeCx7mLzSyjn3/IV9MJQeLPrpOPCPDJ26wrDXJXfB2oYm4VMt4emUfrh/CcXzhc=
Message-ID: <47CF878B.8090101@gmail.com>
Date: Thu, 06 Mar 2008 14:56:27 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Spurious completions during NCQ
References: <20080215134658.GB27745@vlad.carfax.org.uk> <47B6EE53.1070101@rtr.ca>
In-Reply-To: <47B6EE53.1070101@rtr.ca>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Tejun, have the spurious completion fixes been backported
> to 2.6.23 / 2.6.22 yet ?  Those kernels will be in common use
> for some time to come, and this fix is more or less essential.

Not that I know of.  I'm prepping patches now.

Thanks.

-- 
tejun
