Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335AbXDHBLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbXDHBLR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 21:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbXDHBLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 21:11:17 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37890 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752284AbXDHBLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 21:11:16 -0400
Message-Id: <1175994676.2359.1183513514@webmail.messagingengine.com>
X-Sasl-Enc: 9fAZ4zXKIfEgyyB1GWxC/tXCqTiaXUPZis1YRiNB0V5A 1175994676
From: johnrobertbanks@fastmail.fm
To: Valdis.Kletnieks@vt.edu
Cc: "Ignatich" <ignatich@gmail.com>, reiserfs-list@namesys.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <46157B5B.5000602@gmail.com>
   <1175817921.18400.1183285196@webmail.messagingengine.com>
   <1175909205.905.1183425104@webmail.messagingengine.com>
   <1175931932.27274.1183445262@webmail.messagingengine.com>
   <13183.1175965022@turing-police.cc.vt.edu>
Subject: Re: COMPILING AND CONFIGURING A NEW KERNEL.
In-Reply-To: <13183.1175965022@turing-police.cc.vt.edu>
Date: Sat, 07 Apr 2007 18:11:16 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> It is *highly* recommended that you change the kernel identifier at
> least slightly, so that you can install '2.6.20-1.local' without
> overlaying
> the vendor-supplied 2.6.20-1 kernel.  Among other things, this lets you
> boot back to the equivalent code level in the vendor kernel, 
> so you can figure
> out if it's your .config file that's broken, or if you hit a bug
> upggrading from 2.6.19-10 to 2.6.20-1.

I agree. I think your advice is *highly* recommended.

I had this problem once after forcing an upgrade, which removed the
working kernel. I just booted the kernel and stuff, from another
partition.

John.
-- 
  
  johnrobertbanks@fastmail.fm

-- 
http://www.fastmail.fm - The way an email service should be

