Return-Path: <linux-kernel-owner+w=401wt.eu-S932942AbXAWKuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbXAWKuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 05:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932951AbXAWKuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 05:50:18 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:47422 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942AbXAWKuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 05:50:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QZGMCBXu/KSFjSiDZ9amKqnC+NzghCC64eLc4Rgp7306igHDrSPbZsAYvVuylXnRhf55CAaCajSZabTiuof0SWLrYAUS957F/b4UBg6jC4StB+Ov/Dtzxo6pG94yOMb5uj5FkHeNQTds/dpSdTUtKymS4w7CENEPZu/gG9nrjzA=
Message-ID: <9e0cf0bf0701230250nb8d9738redc3e1d963b40bda@mail.gmail.com>
Date: Tue, 23 Jan 2007 12:50:15 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Alon Bar-Lev" <alon.barlev@gmail.com>,
       "Tomas Carnecky" <tom@dbservice.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/26] Dynamic kernel command-line - arm
In-Reply-To: <20070123104140.GA20660@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070118125849.441998000@strauss.suse.de>
	 <20070118130028.719472000@strauss.suse.de>
	 <20070118141359.GB31418@flint.arm.linux.org.uk>
	 <45AF92E7.50901@dbservice.com>
	 <20070118152326.GC31418@flint.arm.linux.org.uk>
	 <20070122221400.GE6262@strauss.suse.de>
	 <20070122222725.GB32085@flint.arm.linux.org.uk>
	 <9e0cf0bf0701230237j5aa1bbya3a70da314e471b9@mail.gmail.com>
	 <20070123104140.GA20660@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> See Message-ID: <20070118152326.GC31418@flint.arm.linux.org.uk> sent on
> 18 January in this thread.  Such strings might as well be initialised to
> an empty string.

So it will be fine if I initialize it to "" and remove the static from
the your example?
BTW: Is there a difference between "" and initialize it to {0}?

Thanks for you help!
Alon Bar-Lev.
