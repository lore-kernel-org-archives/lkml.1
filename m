Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbYCFGF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbYCFGF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 01:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYCFGFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 01:05:09 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:28683 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYCFGFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 01:05:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=FmscCLSKle13QKxAsd6mkYJMmoQXgjeRrkC7Ng/iiMhg+TCxFem8OH7TF+nLmdYjiG7XmdSHV0oN4RRyUwxF/7J7hNzu02jI9oOnMtNhQrq5a7T0d8WdvL3xv8aVHZGtYk0a/fu/w/lUxwQidyNndMyd+M/vQd5XijdHjXbIX6g=
Message-ID: <47CF898D.8060902@gmail.com>
Date: Thu, 06 Mar 2008 15:05:01 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Spurious completions during NCQ
References: <20080215134658.GB27745@vlad.carfax.org.uk> <47B6EE53.1070101@rtr.ca> <47CF878B.8090101@gmail.com>
In-Reply-To: <47CF878B.8090101@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Mark Lord wrote:
>> Tejun, have the spurious completion fixes been backported
>> to 2.6.23 / 2.6.22 yet ?  Those kernels will be in common use
>> for some time to come, and this fix is more or less essential.
> 
> Not that I know of.  I'm prepping patches now.
> 

Oh... it already happened in 2.6.22.15 and 2.6.23.10.  Nice.

-- 
tejun
