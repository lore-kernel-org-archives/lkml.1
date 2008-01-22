Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYAVGHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYAVGHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 01:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYAVGHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 01:07:04 -0500
Received: from hs-out-0708.google.com ([64.233.178.242]:32761 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751241AbYAVGHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 01:07:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kfdL3QE8+DcieqlFL26Kt/+Dzk/mER+PXTo8gMCmc21kjqcKqlIrUqOGpXDqs00+0U1yxs9DBZZnNJJ3EmWwtabM5kgJ4nQZT9rJncoTY1tmGPVbDWIGsxr7jazrvIBcxXJv9qysFMkWHG0ZNKtxTDp+80l49C1xmWb7SXQICco=
Message-ID: <a8e1da0801212206i1dd5e6besc0d4e1c92a58ddda@mail.gmail.com>
Date: Tue, 22 Jan 2008 14:06:59 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH 1/6] driver-core : add class iteration api
Cc: stefanr@s5r6.in-berlin.de, James.Bottomley@hansenpartnership.com,
       a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru,
       linux-kernel@vger.kernel.org, "David Brownell" <david-b@pacbell.net>,
       stern@rowland.harvard.edu, dwmw2@infradead.org, davem@davemloft.net,
       jarkao2@gmail.com, "Cornelia Huck" <cornelia.huck@de.ibm.com>
In-Reply-To: <20080122055434.GB3066@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080112094754.GA2893@darkstar.te-china.tietoenator.com>
	 <20080122055434.GB3066@darkstar.te-china.tietoenator.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 22, 2008 1:54 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>
> Add the following class iteration functions for driver use:
> class_for_each_device
> class_find_device
> class_for_each_child
> class_find_child
>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
