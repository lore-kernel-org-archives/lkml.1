Return-Path: <linux-kernel-owner+w=401wt.eu-S933784AbZLFOh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784AbZLFOh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 09:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbZLFOhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 09:37:55 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.35]:46314 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbZLFOhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 09:37:55 -0500
References: <2a6e8c0d0912052133v3e112bdbx2c95b17437bdd182@mail.gmail.com>
Message-ID: <cone.1260110279.127989.3159.1000@onepiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Ian =?UTF-8?B?RS4=?= Morgan <penguin.wrangler@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: acerhdf: BIOS product mismatch due to whitespace
Date: Sun, 06 Dec 2009 15:37:59 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

Ian E. Morgan writes:
> Having just upgraded my AOA150 to 2.6.32, acerhdf was complaining:
> 
> acerhdf: Acer Aspire One Fan driver, v.0.5.18
> acerhdf: unknown (unsupported) BIOS version Acer/AOA150
> /v0.3310, please report, aborting!
> 
> DMI reports the product as "AOA150         " (i.e. 9 spaces after the
> 6-character model name). This causes the product match to fail, so I
> had to use force_product="AOA150".
> 
> acerhdf: Acer Aspire One Fan driver, v.0.5.18
> acerhdf: forcing BIOS product: AOA150

could you please be so kind and test:
http://piie.net/files/acerhdf_kmod-0.5.22.tar.gz

Thank you!

kind regards,
--peter
