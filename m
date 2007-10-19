Return-Path: <linux-kernel-owner+w=401wt.eu-S1765413AbXJSMtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765413AbXJSMtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbXJSMto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:49:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:8357 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbXJSMtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:49:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=QzZOmpKpc5y2qj6VM79zoBsME1EU8gHZ2fQB7UwkygfsJXoH299olFy+6Q/7KslByUiRCjlEd0HuXK6ujIL+fjS2j05mA43cb3Webe1tCUWf+kxdkDAEolz9hIzYpyfm8dStqsiwbmstMXVB2NI45y/Yh6ggaaA0R1sdfDsoGFg=
Message-ID: <4718A7D1.6010602@gmail.com>
Date: Fri, 19 Oct 2007 16:49:21 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Bryan Wu <cooloney.lkml@gmail.com>, bryan.wu@analog.com,
       i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Blackfin I2C/TWI driver: update for 2.6.24 merge windows
References: <1192456403.6215.5.camel@roc-laptop>	<386072610710172311o7d2207f2he47e16c48016c2c2@mail.gmail.com> <20071019110750.33f66dd8@hyperion.delvare>
In-Reply-To: <20071019110750.33f66dd8@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
 
> BTW, as a rule of thumb, I am ignoring patches that are sent to the
> LKML in addition to the i2c list. 

Why ? The statement would have made sense if the i2c list was not CC 'd, 
but stating that if LK is CC 'd additionally sounds  ...
