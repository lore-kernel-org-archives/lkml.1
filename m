Return-Path: <linux-kernel-owner+w=401wt.eu-S1759683AbXJYKct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683AbXJYKct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 06:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbXJYKcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 06:32:41 -0400
Received: from mail44.messagelabs.com ([216.82.249.179]:37471 "HELO
	mail44.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754044AbXJYKck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 06:32:40 -0400
X-VirusChecked: Checked
X-Env-Sender: amit.walambe@eurotech-ltd.co.uk
X-Msg-Ref: server-3.tower-44.messagelabs.com!1193308358!32096422!1
X-StarScan-Version: 5.5.12.14.2; banners=.,-,-
X-Originating-IP: [194.200.159.164]
Date: Thu, 25 Oct 2007 11:32:36 +0100
From: Amit Walambe <amit.walambe@eurotech-ltd.co.uk>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: x86 compile failure on 2.6.24-rc1
Message-ID: <20071025113236.0d33e31f@eurotech-ltd.co.uk>
In-Reply-To: <20071025102040.GA30907@elte.hu>
References: <20071025100550.637a3af3@eurotech-ltd.co.uk>
	<20071025102040.GA30907@elte.hu>
Organization: Eurotech Ltd.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 12:20:40 +0200
"Ingo Molnar" <mingo@elte.hu> wrote:
> 
> * Amit Walambe <amit.walambe@eurotech-ltd.co.uk> wrote:
> 
> > Hi!
> > I get following error while compiling 2.6.24-rc1 : 
> > 
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > arch/x86/kernel/built-in.o: In function `machine_crash_shutdown':
> > (.text+0x191c8): undefined reference to `genapic'
> > make: *** [.tmp_vmlinux1] Error 1
> 
> see:
> 
>  http://lkml.org/lkml/2007/10/24/128
> 
> 	Ingo
Thanks Ingo!
Sorry for the noise.
- Amit

______________________________________________________________________
This email has been scanned by the MessageLabs Email Security System.
For more information please visit http://www.messagelabs.com/email 
______________________________________________________________________
