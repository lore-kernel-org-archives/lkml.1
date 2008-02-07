Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbYBGThX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbYBGThX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbYBGThJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:37:09 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:27006 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbYBGThH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:37:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ekXjGP+/+lHMZKAOVDtbNbnoqooIkizPoyaehSloo9jwBXTRXvvVfHT52D66YsQ55MMcHWO3t2UGrL3SmyJeerDhbvEJ48uoMAwuUNFmYeUjNNAiO4RwdhhyxtEIArRth5gT//vaobC7hDGOF53rzZrH3W1LWmOXpoeVXSnhTg4=
Message-ID: <386072610802071137i697897dcr2d1c6ecab50f4809@mail.gmail.com>
Date: Fri, 8 Feb 2008 03:37:04 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: blackfin compile error
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>, mpm@selenic.com,
       bunk@kernel.org, bryan.wu@analog.com, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
In-Reply-To: <8bd0f97a0802070803x2497b783o516491ed6249a4fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080206151830.GI505@cs181133002.pp.htv.fi>
	 <1202315015.17934.242.camel@cinder.waste.org>
	 <200802061412.50675.rgetz@blackfin.uclinux.org>
	 <20080206113734.511473b0.akpm@linux-foundation.org>
	 <386072610802062326h4e41a351h28f1d93906784ed0@mail.gmail.com>
	 <8bd0f97a0802070803x2497b783o516491ed6249a4fe@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 8, 2008 12:03 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Feb 7, 2008 2:26 AM, Bryan Wu <cooloney.lkml@gmail.com> wrote:
> > On Feb 7, 2008 3:37 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > The world would be a better place if arch maintainers (or their helpers)
> > > were to build and test -mm once a month or so.
> >
> > I will be here for Blackfin. Actually, we got some patches in -mm, it
> > is necessary to built and test -mm on Blackfin.
>
> ive setup one of our internal machines to auto build all the Blackfin
> defconfigs found in mainline git and the mm tree
>

Thanks a lot, it makes life easier.

> just need to find a way to publish/notify people upon failure ...

Maybe Grace can help to setup some cruisecontrol auto test machine
with email notification.

-Bryan
