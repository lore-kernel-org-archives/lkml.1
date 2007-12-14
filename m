Return-Path: <linux-kernel-owner+w=401wt.eu-S1761604AbXLNRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761604AbXLNRTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 12:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbXLNRTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 12:19:12 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:30915 "EHLO
	outbound7-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750794AbXLNRTL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 12:19:11 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 198.246.171.80;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [i2c] [PATCH 2.6.24-rc4-mm 1/2] gpiolib: basic support for 16-bit PCA9539 GPIO expander[
Date: Fri, 14 Dec 2007 12:15:56 -0500
Message-ID: <F06EB2894F3F0D45AD9BEA7246DE9C9007D3C38B@WCSEXCMBS1.ad.wabtec.com>
In-Reply-To: <20071214170818.72838f75@hyperion.delvare>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [i2c] [PATCH 2.6.24-rc4-mm 1/2] gpiolib: basic support for 16-bit PCA9539 GPIO expander[
Thread-Index: Acg+a+TdEou2gmM/TuywPufNeEckFwACMNFA
References: <f17812d70712100139q31c95d6er12105ebbe94b3909@mail.gmail.com><200712112029.49692.david-b@pacbell.net> <20071214170818.72838f75@hyperion.delvare>
From: <BGardner@Wabtec.com>
To: <khali@linux-fr.org>, <david-b@pacbell.net>
Cc: <linux-arm-kernel@lists.arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
       <i2c@lm-sensors.org>
X-OriginalArrivalTime: 14 Dec 2007 17:15:57.0717 (UTC) FILETIME=[FDEA2C50:01C83E74]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> > > +MODULE_AUTHOR("Ben Gardner <bgardner@wabtec.com>");
> > 
> > But not you?
> 
> I'm not even sure if Ben can be said to be an author of this new
> driver, as there is almost no common code between the old driver and
> the new one.

I agree with Jean here.
Please remove me as the author. 
That'll save me from getting questions about code I'm not familiar with.
=)

Thanks,
Ben

This email and any attachments are only for use by the intended recipient(s) and may contain legally privileged, confidential, proprietary or otherwise private information.  Any unauthorized use, reproduction, dissemination, distribution or other disclosure of the contents of this e-mail or its attachments is strictly prohibited.  If you have received this email in error, please notify the sender immediately and delete the original.


