Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbZLNOpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbZLNOpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbZLNOpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:45:13 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:57431 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbZLNOpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:45:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HdCq6CR7Q9tnzaENu8f6+EEou+vp3Yl4kTkIJ94dIn4piDBCG6MS9R8nhqfa6WF5M2
         OKTOBr2DV4MQHBXKwH3d1GVQvRHs7r4WBA4OjOnFrtHA1Gt1qC2eh98q2aScNVAtnhHk
         bfnofo4Rqevk/viXukjqMc6hEXQzqAN/yGvzY=
MIME-Version: 1.0
In-Reply-To: <200912141751.36699.mithlesh@linsyssoft.com>
References: <c7ac85d60912140256j4e1aa0edn9abba53ab1855ed5@mail.gmail.com>
	 <20091214122649.2d914941@varda>
	 <200912141751.36699.mithlesh@linsyssoft.com>
Date: Mon, 14 Dec 2009 23:45:10 +0900
Message-ID: <c7ac85d60912140645n5dbcadedie1200ce5d3a9cb8d@mail.gmail.com>
Subject: Re: [How to upload our driver to "kernel.org"] Would you give me your 
	advice?
From: Masa <masa.korg@gmail.com>
To: Mithlesh Thukral <mithlesh@linsyssoft.com>
Cc: devel@driverdev.osuosl.org,
       =?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?= <ariveira@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks,

> SubmittingDrivers in the Documentation/ can help you with this.
> Online copy can be found at (amongst many more):
>        http://lxr.linux.no/#linux+v2.6.32/Documentation/SubmittingDrivers
I found it
http://lxr.linux.no/linux+v2.6.32/Documentation/SubmittingDrivers
I will read it.

> If you intend to post the drivers as the development effort continues. so that
> you can have the community feedback (and if required help) during the process
> then you might in interested in Greg's Staging tree.
>        http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=tree
> You can base your patches to the latest kernel (or git trees of respective
> maintainers) and post them to the mailing list.
Oh! Do I have to base our patches to the latest kernel?
May be so.
And the community feedback is important.
It seems to need big effort and we will make every effort anyway.
