Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbZFRA5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbZFRA5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 20:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZFRA5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 20:57:24 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:50235 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbZFRA5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 20:57:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G54/TfVUqVh78xgXnDAIj6Xh6o32BsgKaKmgC415ofoWsQwYV3eK+K1cSRUbaZWKpc
         oDeiGc6S96AjfS1a5KRdCF+KSRkfZb5U3Kuiu2qylJrTinLN4oelIlrobKfoLooUmGmI
         vmLLXNmYt1QNmzxPe+eQlR6nvWOKcvxD0UyQ8=
MIME-Version: 1.0
In-Reply-To: <tkrat.ad6f8fb712020451@s5r6.in-berlin.de>
References: <4A384FE4.9090703@gmail.com>
	 <20090617021254.GQ19977@parisc-linux.org>
	 <tkrat.ad6f8fb712020451@s5r6.in-berlin.de>
Date: Thu, 18 Jun 2009 08:57:25 +0800
Message-ID: <412e6f7f0906171757x673ad9d2u2e116161cba550a0@mail.gmail.com>
Subject: Re: [PATCH] SCSI: explain the hidden scsi_wait_scan Kconfig variable
From: Changli Gao <xiaosuo@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Matthew Wilcox <matthew@wil.cx>, James.Bottomley@hansenpartnership.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 6:07 PM, Stefan
Richter<stefanr@s5r6.in-berlin.de> wrote:
> People keep sending patches to expose CONFIG_SCSI_WAIT_SCAN as a tunable
> item.  These patches aren't accepted upstream, so let's stop the ongoing
> irritation of people due to this obscure and strange installed module
> and its Kconfig option.
Aha, I really like this, and think it works. :)


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
