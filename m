Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbZF1TMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbZF1TMR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 15:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZF1TMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 15:12:08 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33835 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZF1TMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 15:12:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IPnzGgk23UlV//RKokeV+6cpcNf0fpstMrkpaVoSxLpU/T7kXn118iuUHxPYdI/a1q
         GpuqrJGYz86ZhaZId+/n/ZLKY2M0W2Ka5DRgUX240BvlPVY56dJiXz59cJ9isLuKl6vO
         mbjqubwH2AqiF9M3s/oBVEISxklrDXBM5eY2c=
MIME-Version: 1.0
In-Reply-To: <1246214678.13673.31.camel@Joe-Laptop.home>
References: <cover.1246173664.git.joe@perches.com>
	 <1ee6dd55768ebbbeb505c47e2944b683633be630.1246173680.git.joe@perches.com>
	 <20090628185102.47663e61@lxorguk.ukuu.org.uk>
	 <20090628.113325.244931913.davem@davemloft.net>
	 <1246214678.13673.31.camel@Joe-Laptop.home>
Date: Sun, 28 Jun 2009 22:12:08 +0300
X-Google-Sender-Auth: 3353dd19615437b9
Message-ID: <84144f020906281212t495b44baof5b7f7765f23f4c4@mail.gmail.com>
Subject: Re: [PATCH] Remove unnecessary semicolons
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, trivial@kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Sun, 2009-06-28 at 11:33 -0700, David Miller wrote:
>> I'm all for this, to be honest, and I'm very
>> much for rolling this into one single patch too :)

On Sun, Jun 28, 2009 at 9:44 PM, Joe Perches<joe@perches.com> wrote:
> Here's just the single one, but doesn't a patch
> that span multiple arches make it a bit more
> troublesome for the arch maintainers?

I wouldn't think so. Removing double semicolons here and there is
unlikely to cause a lot of merge conflicts.

                        Pekka
