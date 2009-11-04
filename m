Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbZKDTo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbZKDTo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758045AbZKDTo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:44:26 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:35235 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042AbZKDToY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:44:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=w3al4dcaE8sud6bJfMh1d7ufkihIJ38+f4QpEa9kgHAa/dQWtqEGJvLoQtStWcOKLT
         sUkxFN4mc+KHOwiTBan/4uO+sKoInRQ2KFyIbMw1I3qukorgEl/bD9BoZd6iPTg+L3h9
         o9BRKW9w5vE0KWHaj7zN3aLvR0EckbH3WgFS8=
MIME-Version: 1.0
In-Reply-To: <20091104173411.28463.16599.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173411.28463.16599.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 20:44:28 +0100
Message-ID: <14add3d10911041144u6819150eq21a39b1fada9d33b@mail.gmail.com>
Subject: Re: [PATCH 18/41] rt2800pci: add rt2800_rfcsr_[read,write]() wrappers
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 6:34 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800pci: add rt2800_rfcsr_[read,write]() wrappers
>
> Part of preparations for later code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
