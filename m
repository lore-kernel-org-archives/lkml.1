Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbZDWIpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbZDWIpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZDWIpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 04:45:24 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:51919 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbZDWIpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 04:45:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vUBFrHGMSE/5YfV2LRzN9GA3+e5gVBTJZQElfNy99tyuudGe4iV/sdVzxvFv0jzodC
         GYZey5pG37DSr9Ct6FXimjgTk1wtv0yZPd6T7OBiUfV4Lz3FqODBY+olf8TTwpaP1cFV
         rpI95uI1nv5LxVy76DPY+cORGkXlNkmcBoMxg=
MIME-Version: 1.0
In-Reply-To: <49F028CF.4020006@suse.de>
References: <49EF6A4D.3030606@suse.de>
	 <f17812d70904222318n4b742c17y647b8a8ca5273112@mail.gmail.com>
	 <49F028CF.4020006@suse.de>
Date: Thu, 23 Apr 2009 16:45:21 +0800
Message-ID: <f17812d70904230145m131bd506s97539f8383798ee9@mail.gmail.com>
Subject: Re: [PATCH 1/7] mach-mmp: add parameter to clksrc_read()
From: Eric Miao <eric.y.miao@gmail.com>
To: coly.li@suse.de
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Magnus Damm <damm@igel.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 4:37 PM, Coly Li <coly.li@suse.de> wrote:
>
>
> Eric Miao Wrote:
>> This looks to be already fixed by Magnus Damm and merged in recent -rc3.
>>
>
> From my upstream clone, the last commit is
> 49cbe78637eb0503f45fc9b556ec08918a616534, which is
> [ARM] pxa: add base support for Marvell's PXA168 processor line
>
> I don't find Magnus' patch from upstream. Is that patch already merged in some
> sub-system tree ?
>

Sorry, I overlooked it and mistook it with arch/arm/mach-pxa/,
so yes, you have my Ack on this:

Acked-by: Eric Miao <eric.miao@marvell.com>
