Return-Path: <linux-kernel-owner+w=401wt.eu-S1031431AbXD2Uvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031431AbXD2Uvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031438AbXD2Uvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:51:53 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:42830 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031431AbXD2Uvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:51:51 -0400
Message-ID: <46350565.4050801@simon.arlott.org.uk>
Date: Sun, 29 Apr 2007 21:51:49 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Greylisting
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The message identifier is:     1Hhq2P-00023O-Aa
The date of the message is:    Sat, 28 Apr 2007 17:44:42 +0100
  herbert@gondor.apana.org.au
    Delay reason: SMTP error from remote mail server after RCPT TO:<herbert@gondor.apana.org.au>:
    host rhun.apana.org.au [64.62.148.172]: 451-85.158.45.36 is not yet authorized to deliver mail from <simon@fire.lp0.eu>
    451 to <herbert@gondor.apana.org.au>. Please try again later.

The message identifier is:     1HhwWN-0004si-VS
The date of the message is:    Sun, 29 Apr 2007 00:40:06 +0100
  michal@logix.cz
    Delay reason: SMTP error from remote mail server after RCPT TO:<michal@logix.cz>:
    host maxipes.logix.cz [217.11.251.249]: 450 <michal@logix.cz>:
    Recipient address rejected: Service is unavailable
(Definitely greylisting for over an hour despite the generic error message).

The message identifier is:     1HiGA5-0002t6-7p
The date of the message is:    Sun, 29 Apr 2007 21:38:24 +0100
  bunk@stusta.de
    Delay reason: SMTP error from remote mail server after RCPT TO:<bunk@stusta.de>:
    host mailrelay2.lrz-muenchen.de [129.187.254.102]:
    451 Your message has been greylisted, please try again later

This is really starting to annoy me. The LKML itself does it too...

-- 
Simon Arlott
