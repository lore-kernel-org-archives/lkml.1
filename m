Return-Path: <linux-kernel-owner+w=401wt.eu-S1030491AbXBOSlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030491AbXBOSlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030510AbXBOSlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:41:49 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:25519 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030491AbXBOSls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:41:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hDOyceYzbPHcJfpagK/4hY/QsKdK1R/i/cQhBMTOYrarpOB3MLNFhl1n6n6ge/jXYW9IlH2r8+l03tjoOp0R7AOILgLyu2lib1FFnc3FYbm3gZrY2IEwQq12FKjuF0LRPT2GXRBHD8K/5yiJclXT2l7mXOVCZeFelP75xKOz8Uo=
Message-ID: <625fc13d0702151041w3621b18aw299133164db1bde4@mail.gmail.com>
Date: Thu, 15 Feb 2007 12:41:45 -0600
From: "Josh Boyer" <jwboyer@gmail.com>
To: "v j" <vj.linux@gmail.com>
Subject: Re: GPL vs non-GPL device drivers
Cc: "Theodore Tso" <tytso@mit.edu>, "Dave Jones" <davej@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
	 <20070215061149.GE15654@redhat.com>
	 <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
	 <20070215165339.GB5285@thunk.org>
	 <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, v j <vj.linux@gmail.com> wrote:
> So far I have heard nothing but, "if you don't contribute, screw you."
> All this is fine. Just say so. Make it black and white. Make it
> perfectly clear what is and isn't legal. If we can't load proprietary
> modules, then so be it. It will help everybody if this is out in the
> clear, instead of resorting to stupid half measures like
> EXPORT_SYMBOL_GPL.

That does not prevent you from loading proprietary modules.  If your
legal team finds it acceptable to use non-GPL modules, then at your
risk it is possible to modify the kernel source to remove the
restriction anyway.

You are not blocked by this.  Your largest gripe seems to be the fact
that the community does not want to endorse proprietary modules.  For
_your_ use, with advice from _your_ legal team, with _your_ company
assuming any risk, you can certainly continue to use Linux because the
very people you're whining at _did_ contribute the code and provide it
under an Open Source license.  However, I would not want to be in your
position should your company choose to go that avenue and a lawsuit
occurred.

The fact that you're asking for the community to care about
proprietary modules seems odd to me.  It's as if you almost know that
it's legally questionable and you want the community somehow make it
ok to use proprietary modules so you feel better.

Anyway, Linux is not BSD.  If you want something you can take and not
have to care about giving back to, perhaps you should look into that.

josh
