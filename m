Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbZKDTVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbZKDTVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbZKDTVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:21:43 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35923 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbZKDTVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:21:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PsVk3FWoypSkTHV48pCMTHej3OJQNbsX7lNgqs0fScSg1tMKaoeL7FfKLfziv1Hw/0
         J9ypEr//3qWRr5yJetUPXgMLQ7/vIBIDqWnui48XVO4KBxM3Tzavn0lXBT354HhuBqjk
         zmC5NvGnonEraVTKfEpb8I4VxTzWkUYihjmX0=
MIME-Version: 1.0
In-Reply-To: <20091104173334.28463.13649.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173334.28463.13649.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 20:21:46 +0100
Message-ID: <14add3d10911041121l35b875b4pd425312ee57116ba@mail.gmail.com>
Subject: Re: [PATCH 13/41] rt2800usb: add rt2800_regbusy_read() wrapper
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
> Subject: [PATCH] rt2800usb: add rt2800_regbusy_read() wrapper
>
> Part of preparations for later code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
