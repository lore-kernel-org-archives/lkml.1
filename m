Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbXGaILV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbXGaILV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 04:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbXGaILK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 04:11:10 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:40298 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbXGaILH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 04:11:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lRvdguL+W0lyiTHHY59fLLZHSvPx8LJG74kaHGw8HTiEKlMdtkRdbrzxO36/HCBiZy7N6ld7RAfhd3ismk4VyyrGzwWF6qaKnFkqju99VbcgYy346jBEyPEuOmJ4Pk1USlZw7w3dlt/odItrHCpahTP4wsRhOxnoZ5ZwZBArVpE=
Message-ID: <8bd0f97a0707310111rbf76a2bka4857b25ce2bb646@mail.gmail.com>
Date: Tue, 31 Jul 2007 04:11:06 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: bryan.wu@analog.com
Subject: Re: early_printk accessing __log_buf
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org,
       "Greg Ungerer" <gerg@snapgear.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>, "Tim Bird" <tim.bird@am.sony.com>
In-Reply-To: <1185868774.20043.17.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707181756.44074.rgetz@blackfin.uclinux.org>
	 <200707241350.45086.rgetz@blackfin.uclinux.org>
	 <20070724111215.8d91dc7c.akpm@linux-foundation.org>
	 <200707241612.56509.rgetz@blackfin.uclinux.org>
	 <20070724143004.6325a511.akpm@linux-foundation.org>
	 <8bd0f97a0707310047u51c6e46l7e57e8f7bfc4e858@mail.gmail.com>
	 <1185868774.20043.17.camel@roc-desktop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Bryan Wu <bryan.wu@analog.com> wrote:
> why use attachment? You can just paste your patch in the email.

gmail eats inline text and my normal e-mail account is offline atm
-mike
