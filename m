Return-Path: <linux-kernel-owner+w=401wt.eu-S932210AbZDWWK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbZDWWK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760139AbZDWWKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:10:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:35040 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759987AbZDWWKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:10:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GAd3FRu44zCR3HVQpjTkdCgrhFsyWqj7WOaELudfWKPYjp8yXByK5Z04zdkWYyFwVR
         sBx+kENMaTHg3FJfBrHDkbKtBYhITtZzkMHff1lH7+nmhD21njOOornC0y0c7Kb1xBU8
         grUE5X4cs/i25aUkc1CsQpYWig6axAdIyNYEo=
Subject: Re: SDHCI driver runnining in aspire one, allows to write to R/O
 SD cards
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: sdhci-devel@lists.ossman.eu, pierre@ossman.eu,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <49ED0865.9030603@gmail.com>
References: <1240219764.13640.5.camel@maxim-laptop>
	 <49ED0865.9030603@gmail.com>
Content-Type: text/plain
Date: Fri, 24 Apr 2009 01:10:32 +0300
Message-Id: <1240524632.20871.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 17:42 -0600, Robert Hancock wrote:
> Maxim Levitsky wrote:
> > Hi,
> > 
> > I am an owner of aspire one, and it has a card reader.
> > when I take a sd card, and pull down the protection tab, it still allows
> > to write to the card (I tested with my main notebook that indeed, it did
> > write there).
> > 
> > My main notebook, acer aspire 5720, doesn't have this problem.
> > Kernel version in use is 2.6.28 vanilla, but this did happen in former
> > version as well.
> > 
> > 
> > Attached lspci, on acer one.
> 
> Do you know if it worked in any kernel version or OS? It's known that 
> some SD card readers are too cheap to actually implement the 
> write-protect detection.

I'll test in windows, but in linux it never did work.

Best regards,
	Maxim Levitsky

