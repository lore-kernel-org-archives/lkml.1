Return-Path: <linux-kernel-owner+w=401wt.eu-S1752066AbZGTAJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbZGTAJw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 20:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZGTAJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 20:09:51 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:34203 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbZGTAJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 20:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WZRkVIcAsh5W3/lBFN+uJffUay5jbrC87xbiTS3YAJFDnki4p4lfjj8oOEWRYWjF3a
         nTTbujmQ82BcifNSffUQnNB3X2o2JXU5Iw5Oh/AWXfWzli3T5BoSDOxIbukxovQEBicx
         7lZTzCUO3FIS7KY/yfboDOMWQcextZczOOPdE=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0907192212100.11571@localhost.localdomain>
References: <817ecb6f0907191243m33cc7369qa09a24416fad7769@mail.gmail.com>
	 <alpine.LFD.2.00.0907192212100.11571@localhost.localdomain>
Date: Sun, 19 Jul 2009 20:09:49 -0400
Message-ID: <817ecb6f0907191709l2f8b2bfagfc20c70aba844f68@mail.gmail.com>
Subject: Re: [PATCH] x86: NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-cris-kernel@axis.com,
       Roland Dreier <rdreier@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please avoid adding the identical function to both files.
> arch/x86/mm/init.c is the correct place.

Will do.

Thank you.
