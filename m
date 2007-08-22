Return-Path: <linux-kernel-owner+w=401wt.eu-S932758AbXHVW7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758AbXHVW7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932861AbXHVW6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:58:49 -0400
Received: from ns2.suse.de ([195.135.220.15]:46860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762994AbXHVW6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:58:47 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Roland McGrath <roland@redhat.com>
Subject: Re: 2.6.23-rc3-mm1: cannot stat `vdso.so.dbg'
Date: Thu, 23 Aug 2007 00:58:43 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
References: <20070822215639.02D154D0418@magilla.localdomain>
In-Reply-To: <20070822215639.02D154D0418@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708230058.43782.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2007 23:56:38 Roland McGrath wrote:
> > Those patches are in Andi's tree.  His tree has the old versions.  The
> > patches are inter-tangled so it is non-trivial for me to generate
> > incremental patches on top of Andi's tree which bring his old patches up to
> > date with the new ones.  I could of course do so, but it'd be better if
> > Andi's tree weren't carrying old versions of
> > x86_64-ia32-vdso-install-unstripped-copies-on-disk and
> > x86_64-vdso-install-unstripped-copies-on-disk
> > 
> > Please resend those patches to Andi.
> 
> These haven't changed since I sent them (including to Andi) on August 12.

How come they have identical subjects and identical description? How is 
anybody supposed to make sense of this?

-Andi
