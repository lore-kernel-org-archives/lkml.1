Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbZJZWPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbZJZWPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbZJZWPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:15:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:41001 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbZJZWPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:15:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wEAhWtxvUu1jvQKdTCVrgoofMqeZWlXvGsAA37KyMKvLTcW0d6xiijrDDs3R1T5+ME
         3PBiOLaphRoTkZwZyOK/qbsNOpyeXKK++Lpmu/g8oMfzkCqozNTwdaBagC/DYTlB5Sas
         SwRIUD4cVPWi+Pnp/L1oSdm7E35ao55e5tN9o=
MIME-Version: 1.0
In-Reply-To: <20091026.145428.127892659.davem@davemloft.net>
References: <73a01bf20910260850v215385e6q2cbbf9133acd5e1e@mail.gmail.com>
	 <4AE5C7C0.3060305@mayc.ru>
	 <73a01bf20910261059j74bb37a9td472efc21c5440ca@mail.gmail.com>
	 <20091026.145428.127892659.davem@davemloft.net>
Date: Mon, 26 Oct 2009 17:15:48 -0500
Message-ID: <73a01bf20910261515i7ae71042t4cf76d8d677b8944@mail.gmail.com>
Subject: Re: FatELF & patents
From: Rayson Ho <raysonlogin@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: mouse@mayc.ru, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 4:54 PM, David Miller <davem@davemloft.net> wrote:
> A variant of the Sparc SILO boot loader, called TILO, was
> doing this with Sparc Linux kernel images 15 or so years ago.

Patent 5432937:
 Filing date: Aug 20, 1993
 Issue date: Jul 11, 1995

According to the files' copyright header (excluding inflate.c, which
is actually the gzip stuff), the project was started in 1995 or 1996.

http://www.ibiblio.org/pub/packages/infosystems/ultrapenguin/sparc/misc/src/trees/tilo-0.2/src/

Rayson



>
> It packs a 32-bit and a 64-bit Linux kernel into one blob and figures
> out which one to actually boot once it figures out what kind of
> machine it is executing on.
>
