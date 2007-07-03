Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbXGCRz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbXGCRz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 13:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbXGCRzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 13:55:20 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:15022 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbXGCRzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 13:55:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kQVO7FopPgiv4UaIhr2jwr1M5GF8kVAE7wQ9+S7jQs9BLiKVC4afIaBw7ZHh5EL8hxB284FCYrLrYz7nk22mGK5MZm0FAYIs0DmBq1MLuznvsEFreWmT56jNRzNQD97Yxbwy4OlVLAUjwE2/TPtZgEHg/Tirx54zGwa4FlKkZYA=
Message-ID: <8bd0f97a0707031055h7b97c0cerbd2314a2836f7798@mail.gmail.com>
Date: Tue, 3 Jul 2007 13:55:17 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jan Dittmer" <jdi@l4x.org>
Subject: Re: [GIT PULL] Blackfin arch fixes (try #2)
Cc: bryan.wu@analog.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <468A560A.9050801@l4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1183423041.10353.8.camel@roc-laptop> <468A560A.9050801@l4x.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/3/07, Jan Dittmer <jdi@l4x.org> wrote:
> Bryan Wu wrote:
> > Jie's patch is required because we will release our new Blackfin toolchain.
>
> So, what is the new toolchain version?
> gcc 4.1.1 (adi 07r1) / binutils 2.17 doesn't seem to work anymore:

we'll post new toolchain binaries in a bit
-mike
