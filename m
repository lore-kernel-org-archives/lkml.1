Return-Path: <linux-kernel-owner+w=401wt.eu-S1762909AbXHVOx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762909AbXHVOx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762447AbXHVOxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:53:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:16289 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761900AbXHVOxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:53:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ektMQW4dZzP0y1SlU0eyMlr24dnHhb38EIVt+AzC65dCq6LubMakUv3moQNjqbCPHaR3knHYWsR32Wd/ssPI/bPrNLwzeAATsDL0XnM7VvHmSsUFb2M1fI3cTWqOsX2vH4saLZE7p06K7z2a/mXEt5H4ISmKdb4JsAceffrRUmE=
Message-ID: <ab40e9c0708220753l1861cde2wccb58ba931f04b2c@mail.gmail.com>
Date: Wed, 22 Aug 2007 16:53:41 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: how is the boot process of the multicore system
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I am just wondering how is the boot process of the multicore system exactly.
let's say there are 4 cores , what is the booting sequence? and how
does linux realise the booting process?


anyone has any idea?

thanks

regards,

Yang
