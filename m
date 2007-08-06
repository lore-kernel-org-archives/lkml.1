Return-Path: <linux-kernel-owner+w=401wt.eu-S1765474AbXHFReb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765474AbXHFReb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbXHFReY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:34:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50686 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbXHFReX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:34:23 -0400
Message-ID: <46B75B79.3080604@zytor.com>
Date: Mon, 06 Aug 2007 10:33:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Jeff Chua <jeff.chua.linux@gmail.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.23-rc2
References: <Pine.LNX.4.64.0708052005550.3772@boston.corp.fedex.com>    <1186317610.5220.3.camel@daplas>    <b6a2187b0708050626s15e1b7did73f638046c0dba3@mail.gmail.com>    <Pine.LNX.4.64.0708061739100.13469@fbirervta.pbzchgretzou.qr>    <b6a2187b0708060906k643a8a20jcb3ac33259993517@mail.gmail.com>    <39839.81.207.0.53.1186418772.squirrel@secure.samage.net>    <46B75784.5030502@zytor.com> <59814.81.207.0.53.1186421522.squirrel@secure.samage.net>
In-Reply-To: <59814.81.207.0.53.1186421522.squirrel@secure.samage.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
> 
> I thought he was using a VGA console, wouldn't that be in text mode?
> 

That is, exactly, the problem.  It should be, it's not.

	-hpa
