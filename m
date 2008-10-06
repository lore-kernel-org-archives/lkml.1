Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbYJFHsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbYJFHsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 03:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbYJFHse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 03:48:34 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:60364 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYJFHsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 03:48:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=X8/Tmr5orcdTySALgGhVYPG0hMpeilgA3GmGlkwOOEMwfNd27/YpAvxoyRDFuwS6gN
         Hl6Sz9ciR/x3zf+m/o71eKq2vMnn/XfnB2+z2TAJvpGWnZeU/Q0exwXE+w/2rTpdAEav
         JL/qjfm1UzCncPPdQMIGiZXSJ1rD8aTS2ZZ4g=
Message-ID: <1a26b4920810060048h5b4a87c2wc298b01e84815ce6@mail.gmail.com>
Date: Mon, 6 Oct 2008 09:48:32 +0200
From: "Pazzo Da Legare" <pazzodalegare@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: booting uncompressed kernel on x86
In-Reply-To: <1a26b4920810011457t4ad93308u2cc0d2781168f332@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1a26b4920810011457t4ad93308u2cc0d2781168f332@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear ML,

Is there a standard way to boot on i386 arch using uncompressed linux
kernel (vmlinux)?
I'm trying to fast my boot process on a slow i486-like machine, I
found a patch for this subject (http://lkml.org/lkml/2005/7/1/206) but
it doesn't work.

TIA for you help

Pazzo
