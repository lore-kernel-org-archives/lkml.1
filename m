Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbZKDUBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbZKDUBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 15:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758038AbZKDUBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 15:01:47 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:33563 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970AbZKDUBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 15:01:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gjABEeQfDE2/1A/0vQTvcSVhHXqeLOJwgv++GJsT5VkNqbUqBtgeYb3tSYpfhMlUKF
         /RMjON5m1Ii8sZu5jnfvdp4LPD4RqKuIOGVOgFnfOb59SPLFNOktygHkQa6zv4xTBv/n
         II6WD+OZUAjsl7xlVvuohWshGvnQCkMEIuvSo=
MIME-Version: 1.0
In-Reply-To: <20091104173518.28463.61728.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173518.28463.61728.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 21:01:51 +0100
Message-ID: <14add3d10911041201m5fe0eee5j8d20ed62ed022396@mail.gmail.com>
Subject: Re: [PATCH 27/41] rt2x00: fix rt2x00usb_regbusy_read() arguments
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 6:35 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2x00: fix rt2x00usb_regbusy_read() arguments
>
> Add const to 'field' argument of rt2x00usb_regbusy_read()
> (all arguments match rt2x00pci_regbusy_read() ones now).
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
