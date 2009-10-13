Return-Path: <linux-kernel-owner+w=401wt.eu-S933586AbZJMHIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586AbZJMHIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933573AbZJMHIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:08:21 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:53329 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933330AbZJMHIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:08:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rR66x75JO7IByOSLD0SPX4yr6THYmkqlpYQLHAyrXRteYRRfo3SRBrKRiC1ZSxXThY
         4dnLqGVebLixlRbwrttu8XZjSkijmf0cA+ZrghN8heNupYBMtSnH3a1nkir308IW6DlT
         7+vKwq1/Cl4/9LR7zUJimD5wStWfMggTDtY1A=
MIME-Version: 1.0
In-Reply-To: <b637ec0b0910121148g34f46481n1d5d4edb67b0ac55@mail.gmail.com>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
	 <r-4Wjt4coy.A.TPD.dal0KB@chimera>
	 <b637ec0b0910121148g34f46481n1d5d4edb67b0ac55@mail.gmail.com>
Date: Tue, 13 Oct 2009 09:07:42 +0200
Message-ID: <8db1092f0910130007s3a65c432u64e8fc27fb26a650@mail.gmail.com>
Subject: Re: [Bug #14372] Wireless not working after suspend-resume
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       reinette chatre <reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC added

2009/10/12 Fabio Comolli <fabio.comolli@gmail.com>:

[...]
> [  690.553298] wlan0: AP denied association (code=12)
[...]

I have the same code in different situation:
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2089

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
