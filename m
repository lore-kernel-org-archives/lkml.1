Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZDZQGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZDZQGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 12:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbZDZQGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 12:06:10 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45472 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZDZQGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 12:06:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P9/y+gSmsXvjYklrJX/pj1LW44rum6VVvQHG2hADM9aYH9x2bMyN/x5hfp+HS5JktJ
         Ws3LUqXcZp3MBkYqbnYLeu+dyJHHnula3D30J+gYlf2uE1pvouGe7bz7Q+Cx3r7qtT/V
         irhxYgxM5HbtppGax8e2/smzmsAXS7R0WoK9Q=
MIME-Version: 1.0
In-Reply-To: <Fg2zLW93smL.A.qeD.Md48JB@chimera>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
	 <Fg2zLW93smL.A.qeD.Md48JB@chimera>
Date: Sun, 26 Apr 2009 20:06:07 +0400
Message-ID: <a4423d670904260906y3db7e256g371185ec31717054@mail.gmail.com>
Subject: Re: [Bug #13124] ioatdma: DMA-API: device driver frees DMA memory 
	with wrong function
From: Alexander Beregalov <a.beregalov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/25 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13124
> Subject         : ioatdma: DMA-API: device driver frees DMA memory with wrong function
> Submitter       : Alexander Beregalov <a.beregalov@gmail.com>
> Date            : 2009-04-09 12:36 (17 days old)
> References      : http://marc.info/?l=linux-kernel&m=123928064322503&w=4
> Handled-By      : Dan Williams <dan.j.williams@intel.com>

Patch is available, http://patchwork.kernel.org/patch/19621/

Thanks.
