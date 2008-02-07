Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbYBGQD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbYBGQD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbYBGQDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:03:20 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:64947 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbYBGQDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:03:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sWuQ9EdFgZt3xdXoH6bEDXIpOoc7PTPS8zTyGlKWN+OhiisBktwLes0Px0Kf1u5sGRGkR0BPETtLr5tSC5rtPcgDiU4mgm7Ok+xR/bh/mbKos0v9fLvfTnRQoaA+yPtU1ZjnnPZfjHg249922rlV0HxjVgSvJjbVFXUSYCOZohA=
Message-ID: <8bd0f97a0802070803x2497b783o516491ed6249a4fe@mail.gmail.com>
Date: Thu, 7 Feb 2008 11:03:17 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <cooloney.lkml@gmail.com>
Subject: Re: blackfin compile error
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>, mpm@selenic.com,
       bunk@kernel.org, bryan.wu@analog.com, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
In-Reply-To: <386072610802062326h4e41a351h28f1d93906784ed0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080206151830.GI505@cs181133002.pp.htv.fi>
	 <1202315015.17934.242.camel@cinder.waste.org>
	 <200802061412.50675.rgetz@blackfin.uclinux.org>
	 <20080206113734.511473b0.akpm@linux-foundation.org>
	 <386072610802062326h4e41a351h28f1d93906784ed0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 7, 2008 2:26 AM, Bryan Wu <cooloney.lkml@gmail.com> wrote:
> On Feb 7, 2008 3:37 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > The world would be a better place if arch maintainers (or their helpers)
> > were to build and test -mm once a month or so.
>
> I will be here for Blackfin. Actually, we got some patches in -mm, it
> is necessary to built and test -mm on Blackfin.

ive setup one of our internal machines to auto build all the Blackfin
defconfigs found in mainline git and the mm tree

just need to find a way to publish/notify people upon failure ...
-mike
