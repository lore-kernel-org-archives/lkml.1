Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968009Ab0B0IxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 03:53:22 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53889 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967989Ab0B0IxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 03:53:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rlTX+QkD2Gb8/64EbNiiH/Kw1aPm4mqLE73QFBFEMKbctzJsEvEnaOkwjtnboI4Zcj
         Tuf8mUSwc6ruxzwgQDPRosqIEMD3Z0fZu3jTSRi98HoT4i8KGNhwVCnrcjrq9wy3kmZT
         x//C5LLzyzi6KM/mqPPG3xIMWtSZLcoS8VBYA=
MIME-Version: 1.0
In-Reply-To: <fa686aa41002261753i45b9a3e1w478eb1d63b929a74@mail.gmail.com>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
	 <tip-2225a122ae26d542bdce523d9d87a4a7ba10e07b@git.kernel.org>
	 <20100222090710.GA31357@elte.hu>
	 <20100222203319.8bd497a2.sfr@canb.auug.org.au>
	 <20100222102745.GJ20844@elte.hu>
	 <20100222224752.0cbd5807.sfr@canb.auug.org.au>
	 <20100223084552.GB17617@elte.hu>
	 <20100224182540.918b48b0.sfr@canb.auug.org.au>
	 <fa686aa41002261753i45b9a3e1w478eb1d63b929a74@mail.gmail.com>
Date: Sat, 27 Feb 2010 09:53:19 +0100
X-Google-Sender-Auth: 30c041631a6f2afc
Message-ID: <10f740e81002270053o1f86e25cr7b50afd57abe213b@mail.gmail.com>
Subject: Re: linux-next requirements
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hjl.tools@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 02:53, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Wed, Feb 24, 2010 at 12:25 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Anyway, I sick of these discussions.  If people see the way I do
>> linux-next as a problem, then they can find someone else.  That is not
>> the impression I gained at the Kernel Summit and (apart from these
>> occasional "discussions") I am quite happy to continue.
>
> Please don't stop.  I'd be screwed.

Yes, I like linux-next, so
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

(This ack doesn't necessarily apply to the rest of the discussion that
happened on
 linux-tip-commits before. I'm gonna pretend I didn't read it ;-).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
