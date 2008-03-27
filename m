Return-Path: <linux-kernel-owner+w=401wt.eu-S1758311AbYC0Myf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbYC0Myf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbYC0My0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:54:26 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:4940 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000AbYC0MyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:54:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ujpHh70jagGdDjxq/oyRYKjwj3UL8Kg5EK1EZ3NgXkgJnKdtivUkMpYEj7WlCbqiBmXcQ+GAogiBvV346NS2k781MiH5zyFrVcoa3t6pJHCOwthsx39w4An/0Su/4QEw69B2HdXTSV849VFOAPfBFureTpZvkbJjnQ9NnQb/4Ew=
Message-ID: <621d098f0803270554j287ce58eme4b0e52cb6470154@mail.gmail.com>
Date: Thu, 27 Mar 2008 13:54:23 +0100
From: "Jan Dittmer" <jdi@l4x.org>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: linux-next: Tree for March 27
Cc: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080327115459.GB1686@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080327183357.7c637aed.sfr@canb.auug.org.au>
	 <20080327104224.2b98b561@hskinnemo-gx620.norway.atmel.com>
	 <20080327104745.GA1686@cs181133002.pp.htv.fi>
	 <20080327123226.452f0a3f@hskinnemo-gx620.norway.atmel.com>
	 <20080327115459.GB1686@cs181133002.pp.htv.fi>
X-Google-Sender-Auth: 2a2df0fd3b7584b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 12:54 PM, Adrian Bunk <bunk@kernel.org> wrote:
> On Thu, Mar 27, 2008 at 12:32:26PM +0100, Haavard Skinnemoen wrote:
>  > On Thu, 27 Mar 2008 12:47:45 +0200
>  > Adrian Bunk <bunk@kernel.org> wrote:
>  >
>  > > According to Jan's page, there's still a build error with the defconfig:
>  > >   http://l4x.org/k/?d=40450#err
>  >
>  > Hmm...that must be a pretty ancient toolchain.

That's the toolchain from back when avr32 was first integrated in the
kernel. So it may be outdated, but I didn't read any statement on
the contrary. I tend to keep the toolchains stable as long as
possible.

>  > FWIW, a more recent toolchain is available here:
>  >
>  > http://avr32linux.org/twiki/bin/view/Main/BinutilsPatches
>  > http://avr32linux.org/twiki/bin/view/Main/GccPatches

So how can I get notified if I need a more recent toolchain?
IMHO every architecture should have a file somewhere (in
the kernel tree) where the required toolchain versions are
listed and required patches are linked. That would make it
such discussions unnecessary.

Jan


-- 
Jan Dittmer
