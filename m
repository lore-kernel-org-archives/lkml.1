Return-Path: <linux-kernel-owner+w=401wt.eu-S934122AbXGLNZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934122AbXGLNZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 09:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761216AbXGLNYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 09:24:54 -0400
Received: from web26914.mail.ukl.yahoo.com ([217.146.177.81]:38882 "HELO
	web26914.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761151AbXGLNYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 09:24:53 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2007 09:24:52 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=3psNaN/+hm0L4611Otc4vcxLSJapuk+J/gdW4pwwCdDnocvcrzYjNWozAtiMr89DLR/gigWG/IfJGb2utsy8GE74c0kB1fE+IR55r4hK58PbrgWSZzCczBuRF7i4b71vBhg124S/y+zq2nfhXRc1CNm3e1cUfKKCV1ZDNHF+bT8=;
X-YMail-OSG: ad3y4G8VM1l2uMlVSxIVMsygI1JShR4ATryKjVa0Ju44DcT61lh9QwnPN6nGrvgX6M4VwvzQuczv1HUMpaYdETdYDwe6HywP786bDHGdAxAC
Date: Thu, 12 Jul 2007 15:18:12 +0200 (CEST)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re: x86 setup code rewrite in C - revised
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <464301.12723.qm@web26914.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch set replaces the x86 setup code, which is currently all in
> assembly, with a version written in C, using the ".code16gcc" feature
> of binutils (which has been present since at least 2001.)

 ".code16gcc" is useable since a bit earlier than that, in fact since:
http://sourceware.org/ml/binutils/2000-04/msg00021.html
 has been fixed, I am using it every other day.

> The new code is vastly easier to read, and, I hope, debug.

 Yes it is, and there is a lot of work in those 33 patch; in very few of
them I would have liked to read something like "inspired by ..." in one of
the C comments (no need to add any E-mail, I already receive enough spam).

 Etienne.

http://gujin.org


	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
