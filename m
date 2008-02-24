Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbYBXSMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbYBXSMX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 13:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbYBXSMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 13:12:13 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:64935 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbYBXSMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 13:12:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IwwO6SG8v3SyfZkvCvqMVesR82ucTeBUMLrLKlSNoBnMJr2u40MXQ3zv4vXqQDyYPD1tjW20qWDb7z7zQBfnVIXwZhCIqPSY8OEreu4W/K0/Q7p970OOISVuy21a3TYuE9ShWILzCwfCQBLkS54emDzD2QWpvi0klLf3J81swaE=
Message-ID: <4d8e3fd30802241012k3794882fm7f35a86b9481016f@mail.gmail.com>
Date: Sun, 24 Feb 2008 19:12:11 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: [PATCH 0/6] IDE: new series of Coding Style Fixes
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <200802241738.57839.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080223183812.5af6d36d@paolo-desktop>
	 <200802241738.57839.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 5:38 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
>
>  On Saturday 23 February 2008, Paolo Ciarrocchi wrote:
>  > Bart,
>  > here is a new series of patches that remove some errors
>  > and warnings reported by checkpatch.pl from the IDE subsystem.
>  >
>  > All the patches have been compile tested and are against this morning (CET time :-)
>  > linux-next
>  >
>  > Paolo Ciarrocchi (6):
>  >       IDE: Coding Style fixes to drivers/ide/pci/opti621.c
>  >       IDE: Coding Style fixes to drivers/ide/legacy/hd.c
>  >       IDE: Coding Style fixes to drivers/ide/legacy/ali14xx.c
>  >       IDE: Coding Style fixes to drivers/ide/pci/it8213.c
>
>  the above change (patch 4/6) seems to be m.i.a. ?


Yes, sorry about that. I must have forgot to manually send out the patch.
I'll do that as soon as I access again to the linux box.

I really wish to be able to use git-send-mail with gmail,
unfortunatelly it's still not working
even applying all the suggestions I've got from other gmail/git users.

>  >       IDE: Coding Style fixes to drivers/ide/ide-floppy.c
>  >       IDE: Coding Style fixes to drivers/ide/pci/cmd640.c
>  >
>  >  drivers/ide/ide-floppy.c     |    4 +-
>  >  drivers/ide/legacy/ali14xx.c |   11 +++--
>  >  drivers/ide/legacy/hd.c      |   79 ++++++++++++++++++------------------
>  >  drivers/ide/pci/cmd640.c     |   90 +++++++++++++++++++++---------------------
>  >  drivers/ide/pci/it8213.c     |    9 ++--
>  >  drivers/ide/pci/opti621.c    |   50 ++++++++++++------------
>  >  6 files changed, 122 insertions(+), 121 deletions(-)
>
>  I applied all the rest (some with minor fixes).

Good. Where can I look to see the end result of our work?


Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
