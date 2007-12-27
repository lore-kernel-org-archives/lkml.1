Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbXL0R2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbXL0R2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 12:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbXL0R2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 12:28:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:1606 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbXL0R2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 12:28:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gVqbW2nQMtSr68mMsiiWy2fwJjKkmTUU0AnTvr6oBGacIsCOVV0+NuKCkPVRKSxkcVnbZhcIGXd7lSsHfLRIrSE3OnqnbIP+IXE9ASkUOoRcHZnkE6N01tr+I9xvzG67PloYn8rZiZoi68PERuOJxSxP+kTUwFDOfx2rikorm2Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: bbpetkov@yahoo.de
Subject: Re: [PATCH] ide-cd: move the remaining cdrom.c ioctl handling code to ide-cd_ioctl.c
Date: Thu, 27 Dec 2007 16:50:52 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20071226205014.GA7228@gollum.tnic> <20071226215431.GA11415@gollum.tnic>
In-Reply-To: <20071226215431.GA11415@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712271650.52533.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 December 2007, Borislav Petkov wrote:
> On Wed, Dec 26, 2007 at 09:50:14PM +0100, Borislav Petkov wrote:
> 
> Actually you should drop the previous one for it wasn't incomplete. Here's,
> hopefully, a better one :).
> --
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> There should be no functional changes from this.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

applied, thanks
