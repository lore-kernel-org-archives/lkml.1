Return-Path: <linux-kernel-owner+w=401wt.eu-S933783AbXCFBce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783AbXCFBce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 20:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933785AbXCFBce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 20:32:34 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:58399 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933783AbXCFBcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 20:32:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Zhl3D8pKhK6j75XCoA79vR4L0P8o1Cx5nDR6kGQKKn2NzY/zgZGARBfyTwMt2tkM+NDfe6T06ADqusj80zwNYfwFP8tiWKeD/Cbkg8UWhRFX7gcY8ND3KJ9RWNNtd4sjPVGJo3Ulo8Ct9bQTYgmVjxrDJ3AULn6jMeE/Y69J0/g=
Message-ID: <b6a2187b0703051732v79a532f6mbf0d3da857a914e6@mail.gmail.com>
Date: Tue, 6 Mar 2007 09:32:30 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 1)
Cc: "Michael S. Tsirkin" <mst@mellanox.co.il>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>, linux-pm@lists.osdl.org,
       "Ingo Molnar" <mingo@elte.hu>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <20070305000421.GF3441@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <20070226220152.GA29575@stusta.de>
	 <20070228211318.GB4301@mellanox.co.il>
	 <b6a2187b0702281945n5f62a6b5w1c535de3ef9aaa8f@mail.gmail.com>
	 <20070305000421.GF3441@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/5/07, Adrian Bunk <bunk@stusta.de> wrote:

> > I have the same problem on my IBM X60s on rc1 and rc2. Can't resume
> > from RAM, can't suspend to disk. It is possible to revert all the
> > changes to ACPI and test it?
>
> This is with CONFIG_KVM=n?

Yes.
