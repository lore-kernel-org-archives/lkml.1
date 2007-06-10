Return-Path: <linux-kernel-owner+w=401wt.eu-S1763701AbXFJWy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763701AbXFJWy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 18:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759215AbXFJWyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 18:54:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:13734 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758851AbXFJWyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 18:54:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HzumC59Ri4T9TbdOphq6Dxpmy0SVVmekbMO9HcLqVZ3GfAuejK+y8LCOTBc08eORwdfxz/xKj+5LC+4y0WqrGiFcyrJEot0PkBl0dGCvciX2DbDjtXQjqn6lmrr8HNEcJPa3VL+H3urVQ6ftXl6bMsDtQpX2OosgqOE/T2dW2QE=
Message-ID: <a781481a0706101554n259f570bre228faff881ddf4a@mail.gmail.com>
Date: Mon, 11 Jun 2007 04:24:15 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c. Caller 0xc01b00bd
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BAY103-DAV160F003E4B6DBCE103C7C9B21B0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BAY103-DAV1066400DF0615AD677EA1B2730@phx.gbl>
	 <20070316195951.GB5743@melbourne.sgi.com>
	 <BAY103-DAV1484A3797D5368C28969CBB2700@phx.gbl>
	 <BAY103-DAV9C465F21C87A900314523B2760@phx.gbl>
	 <20070320064632.GO32602149@melbourne.sgi.com>
	 <BAY103-DAV7076D9B4230E07680B724B2260@phx.gbl>
	 <20070607130505.GE85884050@sgi.com>
	 <BAY103-DAV141D991980E54836534A00B2250@phx.gbl>
	 <a781481a0706100005wf6b1e4ercfd94d9f4a80bbb@mail.gmail.com>
	 <BAY103-DAV160F003E4B6DBCE103C7C9B21B0@phx.gbl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > On 6/8/07, Marco Berizzi <pupilla@hotmail.com> wrote:
> >> After few hours linux has crashed with this message:
> >> BUG: at arch/i386/kernel/smp.c:546 smp_call_function()
> >
> > Which kernel (exactly) was this
>
> 2.6.21.3
>
> >  and does this occur
> > reproducibly?
>
> I don't know. I try to explain. With all debugging options
> enabled 2.6.21.x has never crashed. After two days 2.6.21.3
> was running without any debug options, it has crashed.
> Tomorrow morning I will start that linux box with linux 2.6.21.3
> without any debug options, and I will keep you informed
> (friday evening I have switched back to 2.6.21.3 with debug
> options enabled, so the machine doesn't crash during the week
> end: this system is my company firewall.)
>
> > Also, could you please send the dmesg,
> [...]
> >
> > stack trace, etc for when this happened?
>
> I have only a monitor bitmap. Tell me if you want it.

Yes, please.

Thanks.
