Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbYHEPd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbYHEPd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756764AbYHEPdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:33:21 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:37255 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755146AbYHEPdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:33:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gL6rfA8vNQd9eKhVFqY0mn7PTg63INmXQzi3sJ45FLHa10qQVowI8PvYViB4FrK78IKiCHevXSLEmXArR1kfBlW5mvHp/X59IqnJTj5ECWl1QQh4ryOTuT+5+nwlU9gHhhX4urtdi+YgjWiwWNCYkHxQaAtlPxCk5gwJkg/k5b0=  ;
X-YMail-OSG: RYNzrHIVM1kqMeVPlIiWrRKofrSn19xkyKjvkRjwTR.FASMMPYDddtJZP1WDK_d5ziCMF8iPGf52Brr1HkCqfriFVpDfvf__NLPwru6fi7Fx2CUWsC16r3E4ulkT893I0Cg-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: jmerkey@wolfmountaingroup.com
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Date: Wed, 6 Aug 2008 01:33:10 +1000
User-Agent: KMail/1.9.5
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Josh Boyer" <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <Pine.LNX.4.64.0808051140150.6309@anakin> <33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808060133.10457.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008 01:02, jmerkey@wolfmountaingroup.com wrote:
> > On Mon, 4 Aug 2008, jmerkey@wolfmountaingroup.com wrote:

> > --
> > Geert Uytterhoeven -- There's lots of Linux beyond ia32 --
> > geert@linux-m68k.org
>
> No I was not, but I am now.  At any rate, I removed the Microsoft-isms
> from the code.  I can cut yet another patch for git6, but git5 was there
> -- GPL2 and all.  How about putting in into the kernel guys -- :-)

Seriously? Because it doesn't seem to have had enough peer review,
it hasn't had widespread testing in somewhere like linux-next or
-mm, and we already have kgdb so you have to also explain why you
can't improve kgdb in the areas it trails mdb.

But the ideal outcome would be if you could contribute patches to
kgdb to the point where it is as good as mdb. It is already in the
tree and supported by a handful of architectures... any chance of
that? (I don't know kernel debugger code, so I ask as an interested
user)
