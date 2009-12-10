Return-Path: <linux-kernel-owner+w=401wt.eu-S1761461AbZLJSpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761461AbZLJSpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 13:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761318AbZLJSpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 13:45:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:42031 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761202AbZLJSpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 13:45:38 -0500
Message-ID: <4B21418E.20906@kernel.org>
Date: Thu, 10 Dec 2009 10:44:30 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Bisected regression
References: <20091210091040.GG8742@kernel.dk>	<20091210103945.GI8742@kernel.dk> <20091210160640.GB27794@elte.hu>	<67EA4830-231F-45C9-A1A6-CE1C6CD9493D@kernel.org>	<20091210180727.GK8742@kernel.dk> <4B213F1F.2020305@kernel.org> <adaocm6n02h.fsf@roland-alpha.cisco.com>
In-Reply-To: <adaocm6n02h.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > mptable mpc is [12 - f011]
> 
>  > what a BIOS !
> 
> Can you be more explicit about what the BIOS is doing wrong?  
> 

bios should not put mpc there.

YH
