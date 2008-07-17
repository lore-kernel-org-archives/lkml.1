Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbYGQDe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbYGQDe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 23:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbYGQDep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 23:34:45 -0400
Received: from mail.vyatta.com ([216.93.170.194]:53022 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYGQDeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 23:34:44 -0400
X-Spam-Flag: NO
X-Spam-Score: -0.345
Date: Wed, 16 Jul 2008 20:34:44 -0700
From: Stephen Hemminger <stephen.hemminger@vyatta.com>
To: Wei Yongjun <yjwei@cn.fujitsu.com>
Cc: Jie Yang <Jie.Yang@Atheros.com>, Roland Dreier <rdreier@cisco.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       "jeff@garzik.org" <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       "jcliburn@gmail.com" <jcliburn@gmail.com>,
       "parag.warudkar@gmail.com" <parag.warudkar@gmail.com>,
       Willy Tarreau <w@1wt.eu>,
       "oliver.schuster@schweigstill.de" <oliver.schuster@schweigstill.de>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] atl1e: Atheros L1E Gigabit Ethernet driver
Message-ID: <20080716203444.181a7375@speedy>
In-Reply-To: <487EBCD3.6040000@cn.fujitsu.com>
References: <72981EBCFD196144B7C6999B9FC34A9A3EE60E9F58@SHEXMB-01.global.atheros.com>
	<20080715211514.25848d8a@extreme>
	<72981EBCFD196144B7C6999B9FC34A9A3EE60EA59C@SHEXMB-01.global.atheros.com>
	<20080716085329.03e97b2a@extreme>
	<adafxq9bxbr.fsf@cisco.com>
	<72981EBCFD196144B7C6999B9FC34A9A3EE613106D@SHEXMB-01.global.atheros.com>
	<487EBCD3.6040000@cn.fujitsu.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 11:30:27 +0800
Wei Yongjun <yjwei@cn.fujitsu.com> wrote:

> Jie Yang wrote:
> > On Thursday, July 17, 2008 12:36 AM
> > Roland Dreier <rdreier@cisco.com> wrote:
> >   
> >>  > Output of checkpatch (scripts/checkpatch.pl in kernel source).
> >>  > Personally, I am not a whitespace bigot, and don't think
> >>     
> >>> all the warnings in checkpatch have to be fixed.
> >>>       
> >
> > Hi, Roland
> >         I used outlook to send these patches, can you give me some
> > aderise on how to send non-mangled patches.
> >   
> 
> You should use Thunderbird to send you patchs. And check it by send the 
> mail to yourself.
> 
> Regards.
> Wei Yongjun

Alternatively, use a text file as attachment. It doesn't work as well but then
it comes through unmangled.
