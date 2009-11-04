Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbZKDTbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbZKDTbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757674AbZKDTbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:31:45 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:59205 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbZKDTbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:31:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uPiu/YGttGM/MSs/YZi0qWeenqCLuDe6oNPsEfH+9+ovFpjXJyhspgYjM9SH759+Ar
         NTxUSP67T5naYd8y2v//Tm9MPlJhahZS2Bhmd3WraQhqFmqm0TwTpkf2K1PRW/rARWc0
         Z2+ZjhpP9YCg7CZ9SVElywVpK1LIrctsQXoRw=
MIME-Version: 1.0
In-Reply-To: <20091104173357.28463.50170.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173357.28463.50170.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 20:31:49 +0100
Message-ID: <14add3d10911041131l45061943h30bf8f3f320429b8@mail.gmail.com>
Subject: Re: [PATCH 16/41] rt2800pci: add rt2800_bbp_[read,write]() wrappers
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 6:33 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800pci: add rt2800_bbp_[read,write]() wrappers
>
> Part of preparations for later code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
