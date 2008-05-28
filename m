Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbYE1Gi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbYE1Gi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 02:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbYE1Git
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 02:38:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:52864 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYE1Gis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 02:38:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c508m5lm53tHm5pL6GmUh3ehZemvecoAfaXL+XTv14ko3g3fTnWfHnHTiqqIWnkB1ylnxFZ9VpRn/7B3GrqCihVzKGGOsmyRwvqFDbZYA/zWOnmWj9ul1Evu7nkdiZaR8dpp7dymp9354P/lP95KmDNrOrWY5+ycZN14pGZ6iAI=
Message-ID: <4104961b0805272338o5fe40727i26b74f195ef1af89@mail.gmail.com>
Date: Wed, 28 May 2008 14:38:42 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] remove Documentation/usb/uhci.txt
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080519220024.GX17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080519220024.GX17716@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 6:00 AM, Adrian Bunk <bunk@kernel.org> wrote:
> The driver was removed before kernel 2.6.0
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
>

But I think this document is still very useful and informative
especially to those who are not quite familiar with UHCI HCDs. It is
not necessary to remove this one at the moment.

Regards
Jason
