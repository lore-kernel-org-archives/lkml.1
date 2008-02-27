Return-Path: <linux-kernel-owner+w=401wt.eu-S1762813AbYB0JKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762813AbYB0JKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 04:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbYB0JKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 04:10:40 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:44695 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbYB0JKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 04:10:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bnbWFEn2HHsHgmioKIfo2qcrczDS9fM98aFTDvbJtiRATUIkGMC9Q3DMVRpJaU5He2g1EYNRU4SBCDdWZAKLxAS9do2T4L8Bo7pBqTzqf0Y/VHa3a0CfDUEeFfuYzXzKdWIDpf8fETO+83smGiR4OM/SsL70/MxNpfUijVXR6eY=
Message-ID: <21d7e9970802270110i1affc67p9fed5696deaef70e@mail.gmail.com>
Date: Wed, 27 Feb 2008 19:10:39 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: drago01 <drago01@gmail.com>
Subject: Re: Reexport init_mm ?
Cc: "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <f6ca9fed0802270029l231c6050sefd90ec2997eda37@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f6ca9fed0802270029l231c6050sefd90ec2997eda37@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 6:29 PM, drago01 <drago01@gmail.com> wrote:
> Hi,
>  init_mm is no longer exported in 2.6.25, because there are no in tree
>  modules that use it.
>  But the closed sources nvidia drivers are using it.
>  Is it possible to reexport this symbol to let the driver work with this kernel?
>

Yes we'll get to it right away...

Oh wait...

Dave.
