Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYGIXWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYGIXWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 19:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYGIXW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 19:22:26 -0400
Received: from outbound-mail-120.bluehost.com ([69.89.18.6]:51393 "HELO
	outbound-mail-120.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754273AbYGIXW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 19:22:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=BNf2kbgaAfzudwlzzKZ779j4WVwZNWg1sNgoUQh6b1epbqdYbuL3/5FXLXISxnGPtfSdVmJD6jVOsmqm6KrXJyduXCej/lHPKeue2PN8l10A6C6ZZUzsoPp7DpFxvYpE;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: next-0708: build failure at drivers/pci/pci-acpi.c
Date: Wed, 9 Jul 2008 16:21:37 -0700
User-Agent: KMail/1.9.9
Cc: "Alexander Beregalov" <a.beregalov@gmail.com>, ak@linux.intel.com,
       lenb@kernel.org, linux-acpi@vger.kernel.org, linux-next@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       David Howells <dhowells@redhat.com>
References: <a4423d670807080518g31402f60j2f624a2ac2db03aa@mail.gmail.com> <200807081040.38777.jbarnes@virtuousgeek.org> <200807082229.33016.rjw@sisk.pl>
In-Reply-To: <200807082229.33016.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807091621.37697.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 192.55.60.9 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 8, 2008 1:29:31 pm Rafael J. Wysocki wrote:
> On Tuesday, 8 of July 2008, Jesse Barnes wrote:
> > David sent me one just like this at 7am this morning, just applied and
> > pushed (along with Alexander's tested-by).
>
> OK, thanks.
>
> Would you like me to send the Stephen's fix for compilation on ppc64
> (CONFIG_PM unset)?

Sure, unless it's already in the ppc tree...

Thanks,
Jesse
