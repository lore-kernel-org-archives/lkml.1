Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbZKKTid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbZKKTid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 14:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758731AbZKKTic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 14:38:32 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:46988 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758669AbZKKTic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:38:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mAKUMhclH/2UFGQC8dNAHwMW3hG7hsna0HcWPsNe8X4o+S25X1v519F23O3EELAbHc
         6LPWgb+noHt6dhXcHXcWOp0rclFZW4zOA0I9eRFwPqzCZcuusHy4vhMEi9ycYFelNU8t
         eA5X0KEdlC9GWS3uc2q8ObpTedB8/VNMASSdQ=
Date: Wed, 11 Nov 2009 20:38:32 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [ RFC, PATCH - 1/2, v2 ] x86-microcode: refactor microcode
 output messages
Message-ID: <20091111193832.GG18592@alberich.amd.com>
References: <1257192496.5941.8.camel@dimm>
 <20091105153742.GA18592@alberich.amd.com>
 <b647ffbd0911051040r3987f63es1279c87bf349bcf6@mail.gmail.com>
 <20091106123403.GB18592@alberich.amd.com>
 <b647ffbd0911060456x5c37ebfapdb2ece392428f66@mail.gmail.com>
 <20091106194626.GC18592@alberich.amd.com>
 <b647ffbd0911070422g154c63bbo2fec62ba63c3c106@mail.gmail.com>
 <b647ffbd0911110807n17933102g39c124a6eff74a44@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0911110807n17933102g39c124a6eff74a44@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 05:07:22PM +0100, Dmitry Adamushko wrote:
> Andreas,
> 
> 
> any progress with this issue?

Yes

> You mentioned that the problem is also reproducible without my
> patches, right?

... and yes.

Fixed with
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=9f15226e75583547aaf542c6be4bdac1060dd425


Andreas
