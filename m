Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbZIRCbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbZIRCbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 22:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbZIRCbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 22:31:17 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:39271 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZIRCbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 22:31:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N88Raj5aW2oruPge2TFg5UDwOLlAMaR0SuhRJDxcrUsRnxesLAJsjlP2d3OwJy7kek
         mbWscZJ5EFBsMpbXC9ExQeP7cM+LyyAIdvhBYvW3wXU6TqST29XycDcSZ+CvcvdzSfbM
         EqvAQrtSq8SLDarq98x+R6bDSyq78p9r8cFr4=
MIME-Version: 1.0
In-Reply-To: <200909161036.346507799@firstfloor.org>
References: <200909161036.346507799@firstfloor.org>
Date: Fri, 18 Sep 2009 10:31:20 +0800
Message-ID: <2375c9f90909171931l2e046d7am79fe1288b09a653d@mail.gmail.com>
Subject: Re: [PATCH] [0/2] Updated patches for gold -X probing
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 4:36 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> based on Sam's feedback using a new macro.
>
> gold build doesn't work currently for some other reasons,
> but I haven't investigated that yet. It seems to be new though,
> wasn't there a few rc*s ago.

Ack for these 2 patches.

Thanks!
