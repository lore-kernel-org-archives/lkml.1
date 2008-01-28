Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYA1BtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYA1BtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 20:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYA1BtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 20:49:12 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:19903 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYA1BtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 20:49:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tXepo6tEwEPlMjI3w2JVnYsSHHYQVr5gHCEfhaub919H/+RvCfhdCW9mA4g5mwnvjH6vUrxTCCvpZH5pP/dUVAkQha38mZXt2bqVrZBdLRBPs7ZZHGvLflrj+XoEbdAy+CUzif5u2ECvxDA6nwKNGSlQt/9JpH654Xa8ybiTmQM=
Message-ID: <86802c440801271749h3c479b81rf1a5edda25f1f259@mail.gmail.com>
Date: Sun, 27 Jan 2008 17:49:08 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/9] x86_64: Switch to .data.compressed in arch/x86/boot/compressed/vmlinux_64.scr
Cc: "Ian Campbell" <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>
In-Reply-To: <479D22CF.6060201@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
	 <d4158549e6497ee261ed220d9cbc8ca8fced8ba7.1201348185.git.ijc@hellion.org.uk>
	 <86802c440801261659s1102f38cr16858d350929b0e1@mail.gmail.com>
	 <1201471499.18241.23.camel@localhost.localdomain>
	 <86802c440801271538xce702c2l6b0ddbccfcdf9553@mail.gmail.com>
	 <479D22CF.6060201@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 27, 2008 4:33 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Yinghai Lu wrote:
> > On Jan 27, 2008 2:04 PM, Ian Campbell <ijc@hellion.org.uk> wrote:
> >> On Sat, 2008-01-26 at 16:59 -0800, Yinghai Lu wrote:
> >>
> >>> can you make 32 bit use .text.compressed instead ?
> >> Any reason to prefer .text? It is data at this stage after all.
> >>
> > it is comressed text insead of compressed data.
> >
>
> No it's not.  It's both.

payload.compressed ?

YH
