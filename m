Return-Path: <linux-kernel-owner+w=401wt.eu-S1762991AbXJNUXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762991AbXJNUXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 16:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbXJNUXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 16:23:08 -0400
Received: from web54404.mail.yahoo.com ([206.190.49.134]:47378 "HELO
	web54404.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753798AbXJNUXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 16:23:07 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Oct 2007 16:23:06 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=eS2nRCdNiyYq6qUao2f1lEF2UTgbpaBqU1oJtpFKcbvEk11mE8xiivFdQU9Luoukf4FHQzUJ2mW8sKb3OveenwGIeMeNaQSUnqtz/qJ2DBMaRCvN+HF8evcTnmqktyL5RAV/bun0n4RaEefFPtlGjlL+T3A8RXkBAIKNkp9s9kw=;
X-YMail-OSG: cvlqjJMVM1lUfJPuHTNs_vBcOVUoBlWeihuvaY2rOT.iqVvHB3WvxZCLez.CE290pnZ8QIyV3i2CzkVWy0QMM5Ax9HxwgboyiYgEb0MujXfv6FoZRTdXVg10MRDLrg--
Date: Sun, 14 Oct 2007 13:16:24 -0700 (PDT)
From: Vlad Codrea <vladc6@yahoo.com>
Subject: Re: [PATCH] : IDE-CS Add additional id string (corsair, 1GB)
To: kristoffer.ericson@gmail.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <313705.92960.qm@web54404.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Could you also add the id strings for the device to
drivers/ata/pata_pcmcia.c?

Thanks,
Vlad


       
____________________________________________________________________________________
Boardwalk for $500? In 2007? Ha! Play Monopoly Here and Now (it's updated for today's economy) at Yahoo! Games.
http://get.games.yahoo.com/proddesc?gamekey=monopolyherenow  
