Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbZJUGP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbZJUGP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 02:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZJUGP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 02:15:26 -0400
Received: from outbound.icp-qv1-irony-out5.iinet.net.au ([203.59.1.105]:9140
	"EHLO outbound.icp-qv1-irony-out5.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622AbZJUGPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 02:15:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au8AAHlE3kp8qNN0/2dsb2JhbAAI2E2EMQQ
X-IronPort-AV: E=Sophos;i="4.44,595,1249228800"; 
   d="scan'208";a="47934881"
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 
 0000000000000004
From: Ben Nizette <bn@niasdigital.com>
To: Jike Song <albcamus@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <df9815e70910202204q5a0593e1gd14b9d36c368861e@mail.gmail.com>
References: <df9815e70910202204q5a0593e1gd14b9d36c368861e@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 Oct 2009 17:15:27 +1100
Message-Id: <1256105727.9801.105.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 13:04 +0800, Jike Song wrote:

> Pid: 3427, comm: Xorg Tainted: G      D    2.6.32-rc5-00011-g2fdc246

the "D" means this isn't the first oops/bug since boot; please post all
bugs and/or full dmesg.  Given all the invalid ioctl noise an Xorg
version might help too.

Thx,
	--Ben.

