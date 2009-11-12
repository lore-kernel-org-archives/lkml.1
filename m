Return-Path: <linux-kernel-owner+w=401wt.eu-S1759846AbZKLAcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846AbZKLAcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 19:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759706AbZKLAcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 19:32:07 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:64183 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759678AbZKLAcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 19:32:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=s4nYJBCSOYDQreOuC+/ynqbfZCBNfZxwJJ5dQIGiHE0WvWtgVjRGg/IcY6e0pXOdKw
         yKM3r8Givh3g9sU06Y1X/ybhqv/Ks1JtUW9qS1yM3rorHxzjK1uv6PSG6wvWGF8bD5h5
         F7xk9QiPu34pYz1WLtQxkjQKlbXmUvsag+pM0=
MIME-Version: 1.0
In-Reply-To: <4ADC71C4.3020805@redhat.com>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
	 <1255906474-25091-4-git-send-email-felipe.contreras@gmail.com>
	 <alpine.LSU.2.00.0910191551030.8582@wotan.suse.de>
	 <4ADC707E.2040802@redhat.com> <4ADC71C4.3020805@redhat.com>
Date: Thu, 12 Nov 2009 02:32:10 +0200
Message-ID: <94a0d4530911111632w4767b704v887629dcf0f2b0e1@mail.gmail.com>
Subject: Re: [PATCH 3/7] crypto: testmgr: fix warning
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 4:03 PM, Jarod Wilson <jarod@redhat.com> wrote:
> So yeah, I rescind my claim that initializing err to 0 is incorrect, I think
> that's just fine.

So is this acked? Who will merge it?

-- 
Felipe Contreras
