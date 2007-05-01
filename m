Return-Path: <linux-kernel-owner+w=401wt.eu-S1423553AbXEAGNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423553AbXEAGNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 02:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423561AbXEAGNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 02:13:21 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:50800 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423553AbXEAGNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 02:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jpkBvMovMAQEXlzp+WpMWM/dnMRC3lLygVHaSaEagdTWb3wwocVHKa6r5CSYKR3ysJ+bwKkj+/fIVKlTkGgcSYoEiLGCtA5v2WxQ8X423nyJbI3TwcskhOOeGbXC1IxDZ+hSIkvYh4npHs2PnrH8wOcUp1mLsvPeTQu+grMAZ3U=
Message-ID: <b6a2187b0704302313p4cb7924bj506d68a1c1b6fb41@mail.gmail.com>
Date: Tue, 1 May 2007 14:13:19 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: nigel@nigel.suspend2.net
Subject: Re: VMware, x86_64 and 2.6.21.
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1177998147.8981.16.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1177998147.8981.16.camel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> Hi.
>
> Does anyone have VMware working on x86_64 with 2.6.21? It's working fine
> for me with 2.6.20, but freezes the whole computer with 2.6.21. Before I


I'm on i386 and noticed it makes the "guest" very unresponsive.

Uncheck "disable write-caching" solves the problem.

Jeff.
