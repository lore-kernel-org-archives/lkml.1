Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbYKYRAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbYKYRAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 12:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYKYRAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 12:00:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:34030 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYKYRAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 12:00:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XTuUytkYSXpmb1dxxE3PIC4Dac0bTB9t/vb6cF41JW6n/auDFCK+MZlj2TlaSSXH9Z
         /sBt0xyLwM13svAP6/cgiwu9bdOMcO9psaaLvjXXZ5pV84nDm0M4EBt358TKSEc/pe6Y
         ZJTPCrfuISSUQVCAIzbSk4qWK6bbNuJ6kS11k=
Message-ID: <9bd6b5360811250900k144ab802k27687ec52d899ad@mail.gmail.com>
Date: Wed, 26 Nov 2008 01:00:22 +0800
From: sniper <s3c24xx@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH 1/7] drivers/ata/pata_radisys.c: cleanup kernel-doc
Cc: "Qinghuang Feng" <qhfeng.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       "Randy Dunlap" <rdunlap@xenotime.net>, linux-ide@vger.kernel.org
In-Reply-To: <492C2A2F.9070309@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491feb5b.08486e0a.075a.4c48@mx.google.com>
	 <492C2A2F.9070309@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> applied 1-7 to #upstream, after combining into a single patch.  I felt a
> single changeset was more appropriate.
>
Hello sir,

That's good, but.
Andrew Morton have got these patches few days ago, and he forgot to Cc to you.
These patches are in mm-trees now. I don't know if it will lead to some problem,
so send this mail to you.
