Return-Path: <linux-kernel-owner+w=401wt.eu-S934268AbXEESLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268AbXEESLI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934267AbXEESLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:11:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52538 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934268AbXEESLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:11:06 -0400
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
	points about ...)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org,
       Johannes Stezenbach <js@linuxtv.org>
In-Reply-To: <463A31EE.20907@gmail.com>
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
	 <46389278.1070208@gmail.com> <20070502155125.280320@gmx.net>
	 <4638C046.1020005@gmail.com> <20070503112013.272380@gmx.net>
	 <4639F554.1040505@gmail.com> <20070503153129.268110@gmx.net>
	 <463A0462.5070106@gmail.com>
	 <d9def9db0705030859y66b1ef8fv22fc844c77bcc3c6@mail.gmail.com>
	 <463A0B36.5080204@gmail.com>
	 <d9def9db0705031019l5083d1c1h607b0829ab526f1@mail.gmail.com>
	 <1178215045.12651.124.camel@localhost>  <463A31EE.20907@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 05 May 2007 15:06:41 -0300
Message-Id: <1178388401.12541.115.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manu,

Em Qui, 2007-05-03 às 23:03 +0400, Manu Abraham escreveu:
> Mauro Carvalho Chehab wrote:
> > Enough. Let's stop arguing non technical issues.
> > 
> > If either one of you have any technical argue against the Trent's
> > patches, please point where the fix is wrong. Otherwise, if you wish,
> > you may send an acked-by agreeing with the fix.
> > 
> 
> Why don't you stop this childish behaviour ?

I just want to solve the current issue, and decide the proper way for Trent's fixes. 

I consider you a very skilled programmer. Unfortunately, it seems that
you're not interested anymore on submitting kernel patches, since your
last contribution, as an author, were back on Aug, 8, 2006:

        commit bbdd11fa957913d6648cabbca59be1da479180ed
        Author: Manu Abraham <abraham.manu@gmail.com>
        Date:   Tue Aug 8 15:48:08 2006 -0300

            V4L/DVB (4432): Fix Circular dependencies

            Signed-off-by: Manu Abraham <manu@linuxtv.org>
            Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org> 

It would be a pleasure to have you contributing again. However, we need to fix the pointed issues.

Also, considering that:

1) the Trent patches addressing the issues exists since august, 2006;

2) nobody pointed any troubles at the current approach;

3) the patch does provide a proper fix for module removal, working well on both hardwares with and without DST;

4) I'm responsible for reviewing and forwarding patches for /drivers/media stuff;

I think there's no reason for me to not forward the proper fixes to mainstream.

-- 
Cheers,
Mauro

