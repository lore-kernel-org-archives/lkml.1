Return-Path: <linux-kernel-owner+w=401wt.eu-S932068AbZKDTUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbZKDTUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757949AbZKDTUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:20:18 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:60161 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622AbZKDTUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:20:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JwMJ7YPJSZxnEqk1CnfpxAGu0jVBah5abfX0KazooXEc5BYyZHzQ4gp3InJFx3SXwh
         d2UqWwYH9T9qUaJPZY8CsPiAe8yk20rTz2mE2CwlM7aqOXvE4R8hnIcak2cROqbqv1bn
         37QmY5PcpGT8nD1+G+RK9OXzz/2XIQsRKepTk=
MIME-Version: 1.0
In-Reply-To: <20091104173327.28463.25410.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173327.28463.25410.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 20:20:21 +0100
Message-ID: <14add3d10911041120u7dfe884dsb5249eb96a14b4c6@mail.gmail.com>
Subject: Re: [PATCH 12/41] rt2800pci: add rt2800_register_multi[read,write]() 
	wrappers
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
> Subject: [PATCH] rt2800pci: add rt2800_register_multi[read,write]() wrappers
>
> Part of preparations for later code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
