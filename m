Return-Path: <linux-kernel-owner+w=401wt.eu-S1761148AbYG3Lal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761148AbYG3Lal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758642AbYG3LaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:30:22 -0400
Received: from smtp4.int-evry.fr ([157.159.10.71]:34501 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386AbYG3LaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:30:20 -0400
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH -next V2] Ignore drivers/video/console/promcon_tbl.c conmakehash generated file
Date: Wed, 30 Jul 2008 13:29:38 +0200
User-Agent: KMail/1.9.9
Cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <200807301156.13432.florian.fainelli@telecomint.eu> <20080730112620.GB19465@uranus.ravnborg.org>
In-Reply-To: <20080730112620.GB19465@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807301329.38642.florian.fainelli@telecomint.eu>
X-INT-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: BDB433EEC6E.12F69
X-INT-MailScanner: Found to be clean
X-INT-MailScanner-SpamCheck: 
X-INT-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

Le Wednesday 30 July 2008 13:26:20 Sam Ravnborg, vous avez écrit :
> Did you test this?
> I recall you should specify filenames relative to the
> path of .gitignore.

Yes it works here with git client version 1.5.6.2.
