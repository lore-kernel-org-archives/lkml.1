Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbXGYXpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbXGYXpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 19:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbXGYXpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 19:45:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:37313 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbXGYXpW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 19:45:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uHc4VBOJFU8VRVZPp3fxyKFU3Hlm1ss1/+Izxf1vxStXe91PVLon34Bkh6mNpU1tU/yICgR/3IlverIV62FKp9VH+3q/HW96dT7GnYvK1GmgUB+PXdJ5yN8nGyi2779pbOoJVuAX/L5eFW0y8dCluQ5knyFvhold51VNg2TUsF4=
Message-ID: <b8bf37780707251645j6ebcd71ao91363b3b90fb32f@mail.gmail.com>
Date: Wed, 25 Jul 2007 20:45:20 -0300
From: "=?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?=" <andre.goddard@gmail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Cc: "Ingo Molnar" <mingo@elte.hu>, david@lang.hm, nickpiggin@yahoo.com.au,
       Valdis.Kletnieks@vt.edu, ray-lk@madrabbit.org, jesper.juhl@gmail.com,
       linux-kernel@vger.kernel.org, ck@vds.kolivas.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, rene.herman@gmail.com
In-Reply-To: <20070725150509.4d80a85e.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <46A58B49.3050508@yahoo.com.au> <46A6D7D2.4050708@gmail.com>
	 <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm>
	 <46A6DFFD.9030202@gmail.com>
	 <30701.1185347660@turing-police.cc.vt.edu> <46A7074B.50608@gmail.com>
	 <20070725082822.GA13098@elte.hu> <46A70D37.3060005@gmail.com>
	 <20070725113401.GA23341@elte.hu> <20070725150509.4d80a85e.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Question:
>   Could those who have found this prefetch helps them alot say how
>   many disks they have?  In particular, is their swap on the same
>   disk spindle as their root and user files?
>
> Answer - for me:
>   On my system where updatedb is a big problem, I have one, slow, disk.

On both desktop and laptop.

Cheers,
-- 
[]s,
André Goddard
