Return-Path: <linux-kernel-owner+w=401wt.eu-S1760120AbXH3Ny6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbXH3Ny6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 09:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbXH3NyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 09:54:22 -0400
Received: from [212.12.190.102] ([212.12.190.102]:33025 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752431AbXH3NyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 09:54:20 -0400
From: Al Boldi <a1426z@gawab.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Override 80-wire cable detection for Toshiba S1800-814
Date: Thu, 30 Aug 2007 16:54:22 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, dex@dragonslave.de
References: <200708300731.20336.a1426z@gawab.com> <20070830110144.1e8020ec@the-village.bc.nu>
In-Reply-To: <20070830110144.1e8020ec@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708301654.22346.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> > Wow!  I have been running 80wire cable detection override on 40wire
> > cables for quite some time without any problem, but I never thought it
> > to be legal if the 40wire cable length is short enough.
>
> Yes.
>
> > How short does it have to be, and can't we have a kernel bootparm to
> > override the cable detection?
>
> For most users the goal should be to automate behaviour. It should just
> work.

What's the max length of a 40wire cable to sustain 80wire cable 
characteristics?


Thanks!

--
Al

