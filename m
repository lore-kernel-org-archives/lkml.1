Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYEPTu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYEPTu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYEPTuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:50:11 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:33836 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbYEPTuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:50:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=OS6J14vDGGFf/FQKvHIw1NlrYJUv55h76+LfU5D3XFK6QKWnymgZmmZeSS/Hl4tIzdi1aU91vof9Gcwd+S6oli+cHKajiudqOEoh/LHrYplTLZlikw5CZ24SpSpG8mAMYTZ8IbsHftFfkkQ5jNE+7re2g9Y1//fztcyOmnSp7gM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.25 -> 2.6.26-rc1: pcmcia flash card changed name from hda to hdc
Date: Fri, 16 May 2008 21:40:48 +0200
User-Agent: KMail/1.9.9
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-ide@vger.kernel.org
References: <20080515132313.GA1558@elf.ucw.cz>
In-Reply-To: <20080515132313.GA1558@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805162140.49501.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 15 May 2008, Pavel Machek wrote:
> Hi!
> 
> After update to 2.6.26-rc1, CF card (in pcmcia slot) moved from hda to
> hdc on thinkpad x60 (and broke my scripts).
> 
> Is that intentional?

Please send dmesgs for 2.6.25 and 2.6.26-rc1 so we can tell more.

Thanks,
Bart
