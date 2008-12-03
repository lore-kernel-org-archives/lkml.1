Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbYLCHMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbYLCHMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 02:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYLCHMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 02:12:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:2420 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYLCHMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 02:12:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=heDmjNk0S8beDN0wdRzTTFuJcbhdWove2ggJ8PIk67G9MRGIgn9e8yoxWexw955GC6
         N3iPkgVQ6B3qYQ1PA9RR6kcYLVLOJTE8TxxT5svGhtDOE+IHSyRqxhX7BKb1LloaIe3V
         5IBB+tnCUBguOm8VkRHnFVlgrd0bXzUy6Uh90=
Message-ID: <e2e108260812022312r28894c29l9a7378d9c7475bb9@mail.gmail.com>
Date: Wed, 3 Dec 2008 08:12:30 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: linux-iscsi-target-dev@googlegroups.com
Subject: Re: [PATCH] [Target_Core_Mod]: Convert to se_task_t->task_sg usage in core and subsystem plugins
Cc: LKML <linux-kernel@vger.kernel.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Boaz Harrosh" <bharrosh@panasas.com>
In-Reply-To: <1228270454.6229.137.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228270454.6229.137.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2008 at 3:14 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>  drivers/lio-core/target_core_base.h      |    2 +-
>  drivers/lio-core/target_core_seobj.c     |   11 ++++++-----
>  drivers/lio-core/target_core_transport.c |    9 ++++-----
>  3 files changed, 11 insertions(+), 11 deletions(-)

Since this patch only contains changes to LIO-specific code, it should
be posted only on the LIO mailing list, and not on the LKML. You are
of course free to CC any individuals you want to CC.

Bart.
