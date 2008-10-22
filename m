Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbYJVTfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbYJVTfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYJVTfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:35:00 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54257 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbYJVTe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:34:59 -0400
Date: Wed, 22 Oct 2008 13:34:58 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org, linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: Possible bug in SCSI Kconfig
Message-ID: <20081022193458.GJ26094@parisc-linux.org>
References: <b637ec0b0810220929r2c889423ma92bef0ec7f9b3b0@mail.gmail.com> <1224702340.6851.20.camel@localhost.localdomain> <b637ec0b0810221225q589ed071i75f559d6fa76d96b@mail.gmail.com> <20081022192650.GI26094@parisc-linux.org> <b637ec0b0810221231w5a329e2cu84c8789e77a4eb59@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b637ec0b0810221231w5a329e2cu84c8789e77a4eb59@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 09:31:51PM +0200, Fabio Comolli wrote:
> Unfortunately this is not an option because of ipw2200. I don't use
> initrd and if I turn off CONFIG_MODULES the kernel hangs forever
> requesting the firmware.

Have you investigated CONFIG_EXTRA_FIRMWARE?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
