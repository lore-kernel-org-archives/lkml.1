Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbYHPKay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbYHPKay (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 06:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYHPKaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 06:30:46 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:51335 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbYHPKaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 06:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FMRMiMyofPm5cBz+HG+wX9v8TJMQ9KMTnshSEOexa6g2MWeuF2JHN7c/5wHeWbnF5M
         4QZKM0RyBSeHIW3sOzNn8FId+QKHumg1o6jnQCRKfZPEUaBcKXtlDSHGz0Srv7zFRuVd
         HNkNrNCheebMZFMoXH9Z559f4XJdEYo1NZ4Yg=
Message-ID: <4d8e3fd30808160330t4ff957ebk8c4dbd89f2c33e73@mail.gmail.com>
Date: Sat, 16 Aug 2008 11:00:45 +0030
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2/5] x86: Coding style fixes to arch/x86/kernel/bios_uv.c
Cc: hpa <hpa@zytor.com>, "Linux Kernel" <linux-kernel@vger.kernel.org>,
       tglx <tglx@linutronix.de>
In-Reply-To: <20080815145257.GL12954@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080802212406.047e8ae6@paolo-desktop>
	 <20080815145257.GL12954@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/08, Ingo Molnar <mingo@elte.hu> wrote:

> hm - i changed your patch to the one below, to align the break's
> vertically, which makes the original variant a lot more readable (and
> even more readable than the new one). Checkpatch still complains about
> it but that's OK, there are always exceptions.
>

thank you Ingo.

ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
