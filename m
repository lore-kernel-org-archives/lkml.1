Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbYKDQ4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbYKDQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbYKDQ4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:56:14 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:51153 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbYKDQ4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:56:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=RK+8bcHgBAtvXac/mfoFJGINHcs4ZljBQ0PjCO2Sxkxz/SIJcRC5FsOGZa/jOx5/SU
         9J5UVg7fpmGumcHgnUp8bule5UKim+bHJ/VDPb1GJwjEE+oNRCKY2HzxJpnU+Kjeo5E8
         WJi0tjuiqOeOkz8o77oaLgcgTqLcdeuVqYTAo=
Message-ID: <6b53b1990811040856w684acf92uc87a761a3be4bab7@mail.gmail.com>
Date: Tue, 4 Nov 2008 14:56:10 -0200
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/6] x86: rename __FIXADDR_SIZE and __FIXADDR_BOOT_SIZE
Cc: linux-kernel@vger.kernel.org, glommer@redhat.com,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20081103091555.GL11730@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1225592633-9948-1-git-send-email-gustavo@las.ic.unicamp.br>
	 <1225592633-9948-2-git-send-email-gustavo@las.ic.unicamp.br>
	 <20081103091555.GL11730@elte.hu>
X-Google-Sender-Auth: d775cc580267e178
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2008 at 7:15 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Gustavo F. Padovan <gustavo@las.ic.unicamp.br> wrote:
>
>> Rename __FIXADDR_SIZE to FIXADDR_SIZE
>> and __FIXADDR_BOOT_SIZE to FIXADDR_BOOT_SIZE.
>>
>> Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
>> Acked-by: Glauber Costa <gcosta@redhat.com>
>
> ok, the patches look nice. Could you please rework them against
> tip/master? We already have a commit in
> arch/x86/include/asm/fixmap_32.h (the DRM speedup patches) which cause
> rejects.

That's ok.

>
>        Ingo
>



-- 
----------------------------------------------
Gustavo Fernando Padovan
Engenharia de Computação 2006
LAS - Laboratório de Administração e Segurança de Sistemas
Instituto de Computação - UNICAMP

gfpadovan@gmail.com
ra061316@students.ic.unicamp.br
pao@jabber.org
-------------------------------------------

Seja Livre, use Software Livre
