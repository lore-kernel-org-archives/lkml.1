Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbZKJQI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbZKJQI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756736AbZKJQIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:08:55 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:56839 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbZKJQIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:08:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JFF1IMeX0g6MNh5m+y7LypSd8wJnV6HiP3qNJ/yD70rvB+cuHgktxge33YEfhALc5u
         Bwe83WmntAFHcPqwHBBvPYhJznBovwvecKAbS7hsY2IN6TO1I7aPclqaYw/rrWLklbYD
         S107C0uwMiP5d14YuFhsyoNvrNGDRymf8IdK8=
MIME-Version: 1.0
In-Reply-To: <200911101651.24912.bzolnier@gmail.com>
References: <1257708657-1232-1-git-send-email-tfransosi@gmail.com>
	 <4AF8F363.3010806@rtr.ca> <200911101651.24912.bzolnier@gmail.com>
Date: Tue, 10 Nov 2009 18:08:59 +0200
X-Google-Sender-Auth: af500aa730ce03a1
Message-ID: <84144f020911100808y55f5bfa2v5c203b356583a7b5@mail.gmail.com>
Subject: Re: [PATCH] ata: Clean up hard coded array size calculation.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Mark Lord <liml@rtr.ca>, Thiago Farina <tfransosi@gmail.com>,
       jgarzik@pobox.com, mlord@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 5:51 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
>> I have to go off and research some silly macro and verify that
>> it does the right thing.
>
> You did it already and the macro name is quite descriptive so you
> may as well just ACK the patch now.. ;)

Indeed. We use the "silly macro" everywhere in the kernel for code clarity.
