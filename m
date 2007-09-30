Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbXI3GbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbXI3GbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 02:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbXI3Ga6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 02:30:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:39539 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbXI3Ga5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 02:30:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ksuzpIoowyQbKH+BVbloonwahFi26+McOI83IGVajxnWXSZ24N5K4purimXxkQ2vcVoVMTiqYztL03uGRVlSE0Y2qS23ZqtN4Jd/LgdzXV76AUAY3G3i++B9IGaKZmTqYN5S5Wp27mJ78CZzzpegP6S151m/booztO2R5GJWeqs=
Message-ID: <517f3f820709292330i56caf106yfa18778d741f8e1a@mail.gmail.com>
Date: Sun, 30 Sep 2007 08:30:55 +0200
From: "Michael Kerrisk" <mtk.linux.lists@gmail.com>
To: "Pierre Peiffer" <Pierre.Peiffer@bull.net>
Subject: Re: [RFC][PATCH 0/2] New API to change the IDs of an existing IPC
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mtk-manpages@gmx.net
In-Reply-To: <20070928165829.5da76796.Pierre.Peiffer@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070928165829.5da76796.Pierre.Peiffer@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

>         As I'm seeing some discussion/interest about IPC, I would like to propose
>  these patches, which provide an easy way to change the ID of an exiting IPC.
> This work is done around the checkpoint/restart of applications. In the case of
> the IPCs, we need (among others) this functionality.

Can you give some more detailed explanation of why this
functionaility is needed.  (Maybe this was explained in other threads,
but if so I've missed it.)

Cheers,

Michael
