Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbYKTO0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbYKTO0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYKTOYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:24:12 -0500
Received: from web56502.mail.re3.yahoo.com ([66.196.97.31]:45141 "HELO
	web56502.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756043AbYKTOYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:24:10 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Nov 2008 09:24:09 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=G39YcHILDbi/X0eb3zDR4V17zrh6bclBlLBwSWU68oGs5ZxypoJzL3kSoqTo7v+FL487KaqOowgZP//WvcdxHFuUwIx3Ve0ESxqaVMSRR20m7lLLksUJjOzmloIF2Ia82tQStD0nnDU8jY+w8Z2YbEJJnPEWPahbwxmtOediOig=;
X-YMail-OSG: hzdD6UoVM1mK.yUkmPafKuV82ew_qebg_X6VMGth2_GDV0VNjCy.Q1jiRdOqC8ZVHJ5gYC3RN.A0lnmlr24dGoQ061Fd0xlMpmN4fRhp1Ysdwb88JNJkHeAO.drQj8.oDFfatwap5TVxQVwLgWy9MBq35IBEUrj8mrfiySA-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 20 Nov 2008 06:17:29 -0800 (PST)
From: Catalin CIONTU <cciontu@yahoo.com>
Reply-To: cciontu@yahoo.com
Subject: linux memory mgmt system question
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <185639.19857.qm@web56502.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> 1. Firstly, we want to know if 'free' is the best
> tool that could give us the most accurate numbers with re to
> used/free memory and swap. If not, what would be that tool
> we could rely on?
> 2. Are there any exceptions that may "fool" free
> utility (inaccurate numbers would be returned), that we
> would need to be aware of? For example, could things like
> huge TLB pages being enabled have an impact on the numbers
> reported by free utility?
> 
> Could you please advise? Thanks a lot.
> 
> 
> Regards,
> catalin.


      
