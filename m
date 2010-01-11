Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374Ab0AKPFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0AKPFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 10:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250Ab0AKPFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 10:05:22 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:35644 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab0AKPFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 10:05:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TafykewK0xE1x7zfw6Bev2yTWXtjuod7bc8F85faPp5m/Om1jhw7dpRQag4pZnBjeG
         u+eilAvBj2tyMM6mqMzNTYc2kRE0svVYgfVwP9gmbkRrcRmhWFh6q6LR0pPfEsVF7g8a
         tW+Vtb8SnynKM0RYcFdng4LFnEY5iIL6NEucs=
MIME-Version: 1.0
In-Reply-To: <omZ8aBZReyD.A.1h.vNlSLB@chimera>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.1h.vNlSLB@chimera>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 11 Jan 2010 07:05:01 -0800
Message-ID: <43e72e891001110705w43524cc6pac1ff6c971926eaf@mail.gmail.com>
Subject: Re: [Bug #14874] Ath5k regression with commit 8bf3d79bc401ca417ccf9fc076d3295d1a71dbf5
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Joshua Covington <joshuacov@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 2:32 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).

This should be closed now.

>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14874
> Subject         : Ath5k regression with commit 8bf3d79bc401ca417ccf9fc076d3295d1a71dbf5
> Submitter       : Joshua Covington <joshuacov@googlemail.com>
> Date            : 2009-12-25 00:49 (17 days old)
> Handled-By      : Luis R. Rodriguez <mcgrof@gmail.com>
> Patch           : http://bugzilla.kernel.org/attachment.cgi?id=24335
>
>
>
