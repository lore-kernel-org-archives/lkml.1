Return-Path: <linux-kernel-owner+w=401wt.eu-S1761444AbZLJSoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761444AbZLJSoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 13:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761203AbZLJSoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 13:44:23 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40992 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761093AbZLJSoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 13:44:23 -0500
Date: Thu, 10 Dec 2009 19:44:29 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Bisected regression
Message-ID: <20091210184429.GO8742@kernel.dk>
References: <20091210091040.GG8742@kernel.dk> <20091210103945.GI8742@kernel.dk> <20091210160640.GB27794@elte.hu> <67EA4830-231F-45C9-A1A6-CE1C6CD9493D@kernel.org> <20091210180727.GK8742@kernel.dk> <4B213F1F.2020305@kernel.org> <adaocm6n02h.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaocm6n02h.fsf@roland-alpha.cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10 2009, Roland Dreier wrote:
> 
>  > mptable mpc is [12 - f011]
> 
>  > what a BIOS !
> 
> Can you be more explicit about what the BIOS is doing wrong?  

I was going to ask the same, so it could be reported and fixed!

> Jens, can you say what BIOS version (18, 19, 20, ...?) you're using?  I
> think I know exactly what box you have.

This is R20.

> I have a pretty good pipeline to the BIOS guys and I can try to get this
> cleaned up if I know the details.

Cool, that'd be nice!

-- 
Jens Axboe

