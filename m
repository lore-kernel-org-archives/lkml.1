Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612Ab0AEOiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0AEOiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 09:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060Ab0AEOiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 09:38:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:57236 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab0AEOiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 09:38:05 -0500
Date: Tue, 5 Jan 2010 06:31:39 -0800
From: Greg KH <gregkh@suse.de>
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: patch
 scsi-mpt2sas-add-missing-initialization-of-scsih_cmds.patch added to
 2.6.32-stable tree
Message-ID: <20100105143139.GA11469@suse.de>
References: <12626340131357@kroah.org>
 <201001042255.07139.s.L-H@gmx.de>
 <20100104234401.GA10770@suse.de>
 <0D1E8821739E724A86F4D16902CE275C1C93D49BBE@inbmail01.lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1C93D49BBE@inbmail01.lsi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 10:13:18AM +0530, Desai, Kashyap wrote:
> Greg and Stefan,
> 
> This patch is counter part of 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=744090d38b47ed8ead8f68b6f0c65866c0b9b17a
> 
> .31 And .32 does not required this patch to be added, since it does not have commit 744090d38b47ed8ead8f68b6f0c65866c0b9b17a.

Thanks for letting us know.  In the future, people might be a bit more
careful about marking patches as "apply this for -stable".

thanks,

greg k-h
