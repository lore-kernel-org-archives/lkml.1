Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbZKQIF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbZKQIF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbZKQIF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:05:26 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:58682 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbZKQIFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:05:25 -0500
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Nov 2009 03:05:25 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MT9/THk/YK7//oFxQTcfYJNaKfd2Vhqdeivob/kIxSOIHLhjgAoH4SLmv5ojIXLa1E
         UVAlNnTyui6uuiOlXZhhDzpqyuCnfL6JsBgYyWdJscUiEPJIhhsZwANlsLfwBgnbq8VD
         AiNUh+z5VNcJYkWJEMyhWSQKF9Qihf9tZVnpQ=
MIME-Version: 1.0
In-Reply-To: <xXQGFmujPl.A.zf.FUdALB@chimera>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.zf.FUdALB@chimera>
Date: Tue, 17 Nov 2009 08:59:12 +0100
Message-ID: <b637ec0b0911162359y188f0829if277467229b095b3@mail.gmail.com>
Subject: Re: [Bug #14372] ath5k wireless not working after suspend-resume - 
	eeepc
From: Fabio Comolli <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The offending commit got reverted in -rc7, therefore this regression is solved.

On Mon, Nov 16, 2009 at 11:37 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14372
> Subject         : ath5k wireless not working after suspend-resume - eeepc
> Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> Date            : 2009-10-03 15:36 (45 days old)
> References      : http://lkml.org/lkml/2009/10/3/91
>
>
>
