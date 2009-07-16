Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbZGPHtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbZGPHtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 03:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZGPHtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 03:49:16 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:25101 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZGPHtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 03:49:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=tcHUR7+CzCaBDIkres6nWlkfrXhBIRGa77gEL3M1Q2nnJjLpPcne/R/Qy0YNXmwVFJ
         HWYumQRD0ePNsS4Yu1KTiSWLGvIMJmVtBcDUpdCek8hGBQn1pWCA6yzbz47nXG6vIs4f
         Kaxh/EZxz9aOpRH9mfY3Neo2SYsnrxsCO+p/0=
MIME-Version: 1.0
Date: Thu, 16 Jul 2009 03:49:14 -0400
Message-ID: <81bfc67a0907160049q3d43093cy52276f0fe1157d89@mail.gmail.com>
Subject: e1000e 2.6.30.1 massive packet loss
From: Caleb Cushing <xenoterracide@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So from 2.6.30 to .1 I noticed that via an icmp test (mtr) 20-50%
packet loss web browsing became impractical (downgrading fixed the
issue). I'm wondering if the change to the driver (w/ msi) is the
cause? also wondering if this is known and will be fixed in .2 I can
provide more information if necessary.

P.S. I'm not on the list, be sure to CC me.
-- 
Caleb Cushing

http://xenoterracide.blogspot.com
