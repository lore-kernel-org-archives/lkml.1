Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbZDVSph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbZDVSph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 14:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbZDVSpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 14:45:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:50580 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbZDVSpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 14:45:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=AlQPUd6D0BzmYSV+SkXdhV9KDJlFomZ7BDRWE7SWrPswuSgwyXfcziWGLg7qkehrb0
         6gR+arKxs2dHPN0xfWH21O/RUb8YFVeqJfQc6DYbq+pEW2sxrS5h0JurfS4t6Er/ZO1J
         gmHJ+CuCqWMge/zAIC9Em+wO5yjzFPHcnJMLE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Bruno =?utf-8?q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Subject: Re: [PATCH 1/2] ide: Stop disks on reboot for laptop which cuts power
Date: Wed, 22 Apr 2009 20:28:33 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: Linux IDE <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux SCSI <linux-scsi@vger.kernel.org>
References: <20090418124415.1dc82273@neptune.home> <20090418124558.0426f74c@neptune.home>
In-Reply-To: <20090418124558.0426f74c@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904222028.33337.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 April 2009 12:45:58 Bruno Prémont wrote:
> My laptop (Acer Travelmate 660) always cuts the power when rebooting
> which causes the disk to emergency-park it's head.
> 
> Add a dmi check to stop disk as for shutdown on this laptop.
> 
> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>

applied
