Return-Path: <linux-kernel-owner+w=401wt.eu-S1761244AbYFKPVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761244AbYFKPVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYFKPVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:21:11 -0400
Received: from web52911.mail.re2.yahoo.com ([206.190.49.21]:42404 "HELO
	web52911.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752155AbYFKPVL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:21:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=vY9x1vhLAhIM7nYjfQM0wnQzZvMSXQqBzSgnExFRZ97OacNQfhwoJ9XxIXsSXAa56GEPC0Hy1MVB0ZBhmDXpyepmvi/xMyUB73ixLGioRJ5c/VjwgWDfng7M7r/CZ7f81DJott8KYA8Lz1fuynlFEUWnBAzf8akcCKvopMi/6xQ=;
X-Mailer: YahooMailWebService/0.7.199
Date: Wed, 11 Jun 2008 08:21:09 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: rankincj@yahoo.com
Subject: RE: [PATCH] sound: emu10k1 - fix system hang with Audigy2 ZS Notebook PCMCIA
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <839605.45533.qm@web52911.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I can't say whether this patch fixes the hang at boot-time with the Audigy2 ZS Notebook card, but my workstation with its Audigy 2 PCI card boots a LOT more quietly with this patch. It used to make a sound like a herd of stampeding elephants rushing past (and had done for quiet a while...), but now is far better behaved.

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail.
A Smarter Email http://uk.docs.yahoo.com/nowyoucan.html
