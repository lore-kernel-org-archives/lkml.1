Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbZCMIG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbZCMIG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZCMIF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:05:58 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:55660 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZCMIF4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:05:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rPVys0uZcSEbGOhjZ0W5tU/MSK9ihyQ5sQTOiVc3VxEqB5+6poZeutf2Yatj350jLK
         Ig9YSfCNBVFEzmxEsp3dKF+E5duX0widPgx5ktF26kQ1HLBOOHD/tq8d29A7n6uvW3BZ
         0D+BAB48uomnDTJDAlgPMMlNlH+RUleZhbVLg=
MIME-Version: 1.0
In-Reply-To: <20090311.015542.118514963.ryusuke@osrg.net>
References: <20090311.015542.118514963.ryusuke@osrg.net>
Date: Fri, 13 Mar 2009 09:05:53 +0100
Message-ID: <81b0412b0903130105y2f9c2430iabaab26d6a8e8188@mail.gmail.com>
Subject: Re: Asking for inclusion of nilfs2 in the mainline kernel
From: Alex Riesen <raa.lkml@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/10 Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>:
>
>  # mount -t nilfs2 -r -o cp=33339 /dev/sdb1 /snap
>  (mount the snapshot, then it will become accessible on the mount point)
>

Is it possible to mount a snapshot rw to make it a branch?
