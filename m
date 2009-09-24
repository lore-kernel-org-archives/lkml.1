Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZIXPjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZIXPjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZIXPjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:39:22 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:56117 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbZIXPjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:39:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Opqrtya9+u587up+ebPr/ZeeiglDCfjtMrN6CD9ULRbWJWvNEIctLb+zsmdgcREiyh
         mbcGl7/S5vH/nOaL0HcPZdxmO1HLkRyJvWPm+lao2m3P+GwBfGha9osxeQO11OAHGiXu
         5t2Qd7QuavUg06L7gUzrIakTqdxJ2QUKzfRzE=
MIME-Version: 1.0
In-Reply-To: <1253788689.5860.2.camel@ht.satnam>
References: <1253788689.5860.2.camel@ht.satnam>
From: "vapier.adi" <vapier.adi@gmail.com>
Date: Thu, 24 Sep 2009 11:39:05 -0400
Message-ID: <8bd0f97a0909240839g7fccd3eg3306d8bc2a537461@mail.gmail.com>
Subject: Re: [PATCH] blackfin: includecheck fix: mach-bf548, ezkit.c
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       uclinux-dist-devel@blackfin.uclinux.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 06:38, Jaswinder Singh Rajput wrote:
>
> fix the following 'make includecheck' warning:
>
>  arch/blackfin/mach-bf548/boards/ezkit.c: linux/input.h is included more than once.

thanks, ive added this to the Blackfin repo
-mike
