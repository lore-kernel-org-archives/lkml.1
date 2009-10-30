Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbZJ3Fmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbZJ3Fmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 01:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbZJ3Fmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 01:42:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:61594 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbZJ3Fmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 01:42:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gRsrg6C7afnHHw2+YNU/gR+90sl5W97uMnpSU28AJgsZwmpwzbYrUHp4lXlQa8+pR9
         khZWtXwsc4gKT+CzPowZyZFiMWI9kI78jsXw/J2uVAZCPDD/PxSBhBTBhpzYKWNv/wEE
         JNwLLCQGgpgajPF2YiLzA0sB438hr0hn5kk5o=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
Date: Fri, 30 Oct 2009 00:42:41 -0500
Message-ID: <73a01bf20910292242j4558da75i221293bc10cdc867@mail.gmail.com>
Subject: Re: FatELF patches...
From: Rayson Ho <raysonlogin@gmail.com>
To: "Ryan C. Gordon" <icculus@icculus.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 9:19 PM, Ryan C. Gordon <icculus@icculus.org> wrote:
> What's the best way to get this moving towards the mainline? It's not
> clear to me who the binfmt_elf maintainer would be. Is this something that
> should go to Andrew Morton for the -mm tree?

Can we first find out whether it is safe from a legal point of view??
After the SCO v. IBM lawsuit, we should be way more careful.

Like it or not, Apple invented universal binaries in 1993, and so far
we are not able to find any prior arts...  If we integrate something
that infringes Apple's patent, then Apple can ban all the Linux
distributions and devices from shipping.

Rayson



>
> --ryan.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
