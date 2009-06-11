Return-Path: <linux-kernel-owner+w=401wt.eu-S1760380AbZFKTyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760380AbZFKTyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbZFKTxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:53:52 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:38880 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208AbZFKTxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:53:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=FybPEx5PDd/B4AL+wUmAnAtykWtDSMCQsGe6ZB3MhDqfta4ibB9vDgi+DooatcUZNm
         dgQIWCRNUmKMuv5OfYf7w5VWpHOmClvl6KOupMpMikJ8n5pJ2YWRLv8KWrQ0aP95J+F0
         nywlkrcH1NY3wThiENtT9z8nSHrxKT+gCBSNE=
From: Diego Calleja <diegocg@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] first block round for 2.6.31
Date: Thu, 11 Jun 2009 21:58:41 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc7-00149-g3218911; KDE/4.2.2; x86_64; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>, Tejun Heo <tj@kernel.org>,
       Steven Rostedt <srostedt@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <20090611111339.GQ11363@kernel.dk> <20090611182657.GY11363@kernel.dk> <alpine.LFD.2.01.0906111134180.3573@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906111134180.3573@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906112158.41458.diegocg@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jueves 11 Junio 2009 20:42:04 Linus Torvalds escribió:

> [ Anybody with enough google-fu to find my rant, so I don't have to 
>   re-rant? ]

My google-fu is not great, but I usually save the most interesting rants.

http://www.mail-archive.com/dri-devel@lists.sourceforge.net/msg39091.html
http://lkml.org/lkml/2008/5/16/540
