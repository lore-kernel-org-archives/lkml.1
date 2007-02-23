Return-Path: <linux-kernel-owner+w=401wt.eu-S932495AbXBWSCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495AbXBWSCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 13:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932500AbXBWSCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 13:02:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:52585 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495AbXBWSCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 13:02:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J2FhaQu7JwlUJPNDuwSEjP49VdKbmsuLVwNrfeNTNFnCT5yP5hUtgX7NPbSNSm6H1E6UBV8GoL1YXY26jX3J+toxb58WDYhE3tYKWQMsRbtocyCRqcOUJJrbik7OMiJDKtoPWRgsNTwXrI5PU05judviWL53TTHqb0UeXQYMwIA=
Message-ID: <a02278b00702231001m911bd3cy937f88377e85be6@mail.gmail.com>
Date: Fri, 23 Feb 2007 10:01:57 -0800
From: "Allexio Ju" <allexio.ju@gmail.com>
To: "Frederik Deweerdt" <deweerdt@free.fr>
Subject: Re: trivial question regarding byte ordering
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070223152411.GA31486@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a02278b00702230718i74df1d63g954bd7ac83298696@mail.gmail.com>
	 <20070223152411.GA31486@slug>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/23/07, Frederik Deweerdt <deweerdt@free.fr> wrote:
> including include/asm/byteorder.h will define the needed
> cpu_to_{b,l}e{16,32,64} and {b,l}e{16,32,64}_to_cpu macros.
Great, Thank you for your answer.

Regards,

Allexio
