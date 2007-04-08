Return-Path: <linux-kernel-owner+w=401wt.eu-S966033AbXDHBCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966033AbXDHBCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 21:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966020AbXDHBCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 21:02:37 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58359 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966033AbXDHBCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 21:02:37 -0400
Message-Id: <1175994157.1894.1183513166@webmail.messagingengine.com>
X-Sasl-Enc: 2dzVqgBId65L90nHGr8LSmD2At6LgMeoopuki95xABQ1 1175994157
From: johnrobertbanks@fastmail.fm
To: Valdis.Kletnieks@vt.edu
Cc: "Ignatich" <ignatich@gmail.com>, reiserfs-list@namesys.com,
       linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <46157B5B.5000602@gmail.com>
   <1175817921.18400.1183285196@webmail.messagingengine.com>
   <1175909205.905.1183425104@webmail.messagingengine.com>
   <12252.1175964174@turing-police.cc.vt.edu>
Subject: Re: COMPILING AND CONFIGURING A NEW KERNEL.
In-Reply-To: <12252.1175964174@turing-police.cc.vt.edu>
Date: Sat, 07 Apr 2007 18:02:37 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> It is quite possible to build a kernel that has all the drivers built-in,
> but still require an initrd file.  For instance, if you have a recent
> RedHat or Fedora system, '/' may very well be on an LVM partition, which
> means you need an initrd to do a 'lvm varyonvg' before mounting your real
> root filesystem will work....

Thanks Valdis,

Thats interesting, I didn't know that. 

Do you know if deb-pkg and rpm-pkg take care of creating the initrd
automatically.

I seriously doubt they do.

Actually, I guess I only need to compile another kernel to find out.

John.
-- 
  
  johnrobertbanks@fastmail.fm

-- 
http://www.fastmail.fm - Choose from over 50 domains or use your own

