Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbZFYRef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbZFYRef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbZFYRe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:34:28 -0400
Received: from mailhost19.gawab.com ([66.220.20.19]:50686 "HELO
	info33.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752667AbZFYRe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:34:27 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Marcel Holtmann <marcel@holtmann.org>, Brian Marete <bgmarete@gmail.com>
Subject: Re: Regression: Problem in using USB Bluetooth Dongle (Worked fine in  2.6.24.x)
Date: Thu, 25 Jun 2009 20:35:27 +0300
User-Agent: KMail/1.5
Cc: LKML <linux-kernel@vger.kernel.org>, linux-bluetooth@vger.kernel.org
References: <6dd519ae0905080528j79640bb0l8fe475b2f09e6bc4@mail.gmail.com> <6dd519ae0906231314k930be18p296281c1e59ba798@mail.gmail.com> <1245791641.15367.143.camel@violet>
In-Reply-To: <1245791641.15367.143.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906252035.27575.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
> > The regression persists even in the latest kernels.
> >
> > Decided to collect some more debug information on this problem. This
> > output is from the same system detailed above running on
> > kernel 2.6.28.10:
>
> the latest kernel is 2.6.30 btw. Can you please test that one.

I just tried 2.6.30 and it's still broken since 2.6.27.


Thanks!

--
Al

