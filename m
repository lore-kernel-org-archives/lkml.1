Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbZBSN6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbZBSN6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZBSN6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:58:42 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:49061 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbZBSN6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:58:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UbF/D0RfI7ZhFlfZKKE5nRI3UbJ4poxApXnFOE4OIPncxFmn5TDXsKU1nTOu0ihSNZ
         PzlNph8y0bAgi7CgYNIPcNjefIAht/d0UmSnr2iMxd7eZZAD/BMC9ysaNUhipaARs+Pd
         7vtH36ugUjqZ9L39C6zKeExBpGdJkEb11oJnI=
MIME-Version: 1.0
In-Reply-To: <1235051161-8858-1-git-send-email-eric.y.miao@gmail.com>
References: <1235051161-8858-1-git-send-email-eric.y.miao@gmail.com>
Date: Thu, 19 Feb 2009 21:58:40 +0800
Message-ID: <f17812d70902190558g12eddb02n9d1430fd44cdc4e@mail.gmail.com>
Subject: Re: [PATCH 0/12] ARM: add base support for Marvell PXA168
From: Eric Miao <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 9:45 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
>
> This patch set adds base support for Marvell's PXA168 application
> processor.
>
> Excerpt from Marvell's PXA168 Product Brief:
>
> """The Marvell(R) PXA168 processor is the first in a family of application
> processors targeted at mass market opportunities in computing and consumer
> devices. It balances high computing and multimedia performance with low
> power consumption to support extended battery life, and includes a wealth
> of integrated peripherals to reduce overall BOM cost ... """
>
> For more information, please see
>
>  http://www.marvell.com/featured/pxa168.jsp
>

FYI, those who are interested in the git repository, please check:

git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git pxa168

-- 
Cheers
- eric
