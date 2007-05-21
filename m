Return-Path: <linux-kernel-owner+w=401wt.eu-S1762494AbXEUMOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762494AbXEUMOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 08:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756888AbXEUMO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 08:14:28 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:26298 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbXEUMO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 08:14:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=NxVW04vMfUtPNnuY3kAHi2DlThEjV8BPzn/bc4EUR3CUc4QWElWOhxwktZfRvOD1+saM3t5P/1yxiV622LlAzv6fvQDiX1yXPlCN7gyyhgD1aqzz99v+5F3TWHadn08FwA2M2NN/KKmyNnb+LEqRsH9lm1YdkX8a7PxPucumNjM=
Message-ID: <84144f020705210514y396f6e67r57b86362a10f44f1@mail.gmail.com>
Date: Mon, 21 May 2007 15:14:12 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH 12/32] Blackfin arch: Fix bug using usb keyboard crashes kernel
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <600D5CB4DFD93545BF61FF01473D11AC0B174C8F@limkexm2.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <600D5CB4DFD93545BF61FF01473D11AC0B174C8F@limkexm2.ad.analog.com>
X-Google-Sender-Auth: f74be0e88cfa699e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Hennerich, Michael <Michael.Hennerich@analog.com> wrote:
> I was fixing this issue some time ago.

[snip]

Makes sense. Please consider adding this to the changelog. Thanks.

                        Pekka
