Return-Path: <linux-kernel-owner+w=401wt.eu-S1760139AbZDOMuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139AbZDOMuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759354AbZDOMt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:49:57 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:62196 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759407AbZDOMt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:49:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qAGEyWJj6W0ugQ7MDc4J+TkfN8+auPw7PMZCU32RgkYk+HQHm05gUUG35eeP7zCR80
         aG/BK/CwILv/5CKk3Ife6lXt33lOaxrXgjY8udPBhYPYBXO13cupOklwFlWtstiWqdqK
         kHk6VILdvlbc/FVyybd5avCuxY8nj98+3G6Ws=
MIME-Version: 1.0
In-Reply-To: <671763813@web.de>
References: <671763813@web.de>
Date: Wed, 15 Apr 2009 14:49:54 +0200
Message-ID: <2d05c4580904150549q1768e872h34db393ae7bd1b44@mail.gmail.com>
Subject: Re: Fast testing
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: devzero@web.de
Cc: LKML <linux-kernel@vger.kernel.org>, tilman@imap.cc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well the idea wasn't about what is faster, rebooting or loading
kernel image in ram memory, it was about loading kernel image
in ram to see and debug things. And if you reboot there is
time delay and the point is why doing it, if you can just smash
another kernel image in ram memory and drive.

I mean, this does not make sense in production environment use,
it is for debugging.

Anyway, the simplest first try is to get somehow at grub command
line and load kernel image in ram and hope this works :)
If not, then write small program is the only solution.

The only concern is can you burn your laptop with assembly instructions ?? :)

thanks,

Dragoslav Zaric

[Programmer; M. Sc Astrophysics]
