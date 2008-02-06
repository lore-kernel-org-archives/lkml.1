Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbYBFPhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbYBFPhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 10:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbYBFPhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 10:37:38 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:51852 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYBFPhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 10:37:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=V274kJKq7dOmPm/vTcTZitWaBIf1x1mitouEzkgh1dtqisv8M0pz0VPGEWUlgqFUCgEeuWlb/KILRwYE01+HyxHHlu6KjwizsCRJYZdzB+7qvK2XaW86wgX/Qu8KQb4ccLyhzMup2FB8pIjMAUtjzPJZFZRPMqJC6VC8X6HWTPY=
Message-ID: <b6c5339f0802060737q5b3232c1u26311fe2bcfa7b48@mail.gmail.com>
Date: Wed, 6 Feb 2008 10:37:32 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Tino Keitel" <tino.keitel@gmx.de>
Subject: Re: ath5k failure with 2.6.24-git14
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <20080206014131.9d489a34.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080205225746.GA4532@dose.home.local>
	 <20080206014131.9d489a34.akpm@linux-foundation.org>
X-Google-Sender-Auth: 0628506005f000ec
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 5 Feb 2008 23:57:46 +0100 Tino Keitel <tino.keitel@gmx.de> wrote:
>
> > Hi,
> >
> > I tried the current git (9ef9dc69d4167276c04590d67ee55de8380bc1ad) and
> > got the following error message from ath5k:
> >
> > ath5k_pci 0000:02:00.0: registered as 'phy0'
> > ath5k phy0: failed to resume the MAC Chip
> > ath5k_pci: probe of 0000:02:00.0 failed with error -5

Hi Tino,

I have the same chip and it is currently unsupported by ath5k.  See:

http://marc.info/?l=linux-wireless&m=120179743111458
