Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbZFKDIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbZFKDIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 23:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbZFKDIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 23:08:00 -0400
Received: from louise.pinerecords.com ([213.168.176.16]:54010 "EHLO
	louise.pinerecords.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbZFKDH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 23:07:59 -0400
Date: Thu, 11 Jun 2009 05:07:59 +0200
From: =?utf-8?B?VG9tw6HFoSBTesOpcGU=?= <szepe@pinerecords.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.28.x FIX] CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK
Message-ID: <20090611030759.GA25569@louise.pinerecords.com>
References: <20090611024019.GC25384@louise.pinerecords.com> <20090611024641.GA19767@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090611024641.GA19767@suse.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Fix: CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK.
> > Patch against 2.6.28.10.
> > 
> > inlined please find a trivial fix that makes it possible to run
> > complete systems out of an initramfs on 2.6.28.10 again (this
> > broke somewhere between 2.6.27 and 2.6.28).
> 
> 2.6.28 is no longer supported, sorry.
> Is this an issue in 2.6.29 or 2.6.30?

Yes.  I also sent a patch (in a separate email) that applies
on 2.6.29.x, 2.6.30.x, and current git master branch head.

Best regards,
-- 
Tomáš Szépe <szepe@pinerecords.com>
