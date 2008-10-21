Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbYJUBa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbYJUBa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 21:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYJUBaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 21:30:18 -0400
Received: from outbound-mail-144.bluehost.com ([67.222.38.34]:35089 "HELO
	outbound-mail-144.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751715AbYJUBaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 21:30:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=MTjfJ6Gm7CN3QHdiwH/rJh58yR/wuPsDDT49jvywMf/+M4OnoOXmgIrgIVzHPg3fsI0V5Xan3w4h+A6gVpWIXMO/7o+01jGoAsDSDlfaaLX4fLHtljdAkEezjx99u345;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] pci: Fixing drivers/pci/search.c compilation warning.
Date: Mon, 20 Oct 2008 18:29:58 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: linux-pci@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Rakib Mullick <rakib.mullick@gmail.com>
References: <b9df5fa10809280816u23ef3021k7eee287a237b72ae@mail.gmail.com> <20080928163211.GR27204@parisc-linux.org> <20081021011308.GA3889@parisc-linux.org>
In-Reply-To: <20081021011308.GA3889@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810201829.58541.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 20, 2008 6:13 pm Matthew Wilcox wrote:
> This patch seems to have been overlooked.  It also seems to have had
> some kind of midair collision with a patch from Greg that ignored the
> real bug I found.
>
> Here's an updated version.  I think it should also be applied to
> -stable.

Ah I didn't get Cc'd but I should have seen it on linux-pci.  Queued up for my 
next pull, thanks Matthew.

Jesse
