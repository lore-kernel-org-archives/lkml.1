Return-Path: <linux-kernel-owner+w=401wt.eu-S933455AbXCWGsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbXCWGsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 02:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933679AbXCWGsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 02:48:31 -0400
Received: from smtp001.mail.ukl.yahoo.com ([217.12.11.32]:23723 "HELO
	smtp001.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933455AbXCWGs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 02:48:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ur8R6pEPBOmuJQRwxoXy5SinecVvCUXiFpldkkutTmpEI32trNzCtIdp3vYUMuG3xhEJPYM6WtnsAO/FBULK3JDK5ncDsXj1dx0ofOM8FbFyo0CDT3S+0Qj9ryRGno5X7tyPn/GYo/baOtkKFCsC189WT+b2ljC1UAYsCWqN7qc=  ;
X-YMail-OSG: pOPqehkVM1m_KcUTzCuK9FGlWj.LrmRB34qYumzfW.W3ci8gpO9rh4ZhYTZMHSl8aWrpSOCCsORa4SPpfz79MvVQV9zKrdrOXhy1r4y5PfJNyjKhd60fq6NYLOh2sKox9puH8fTmVaPE
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [ PATCH 4/7 ] UML - create as-layout.h
Date: Fri, 23 Mar 2007 07:47:50 +0100
User-Agent: KMail/1.9.5
Cc: Jeff Dike <jdike@addtoit.com>, LKML <linux-kernel@vger.kernel.org>
References: <20070322160643.GA7012@c2.user-mode-linux.org>
In-Reply-To: <20070322160643.GA7012@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703230747.50306.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 March 2007 17:06, Jeff Dike wrote:
> This patch moves all the the symbols defined in um_arch.c, which are
> mostly boundaries between different parts of the UML kernel address
> space, to a new header, as-layout.h.  There are also a few things here
> which aren't really related to address space layout, but which don't
> really have a better place to go.

Hey, I do like _these_ patches! A nice picture in that header could then be 
added (in the very future ;-) ), but at least one knows there are so much of 
them. And user_util.h is no more!

;-)

Bye!
-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
