Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbYBXVTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbYBXVTs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 16:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbYBXVTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 16:19:38 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:48757 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbYBXVT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 16:19:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KCb6gOuhhC4J052ZnOKjP53Ar1E3QgIzRdrgALhmdiNjkzx2iEDkKRr23yYzfg/O8AsICab8TBBxrepBKd+Mys4CU2ddxrRJHnTjtCxUjMjRqbpx4evwunyGoxZA0YyJbZZ2mDJ1ZZbgXAE3angfa2cZvPwwH89A2E46l1Ea/mM=
Message-ID: <4d8e3fd30802241319i3a633f7an6c2b429eb8b55d6b@mail.gmail.com>
Date: Sun, 24 Feb 2008 22:19:21 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: [PATCH 0/2] x86: 2 Coding Style patches
In-Reply-To: <20080224115630.45d09aea@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080224115630.45d09aea@paolo-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This email didn't reach lkml...

Hi Ingo,
 two more coding style patches.
 Compile tested, against x86/testing 4a6af5bbbd74dd812224900d3468b008d117da29

 Paolo Ciarrocchi (2):
      x86: Coding Style fixes to arch/x86/power/cpu_32.c
      x86: Coding Style fixes to arch/x86/kernel/cpu/common.c

  arch/x86/kernel/cpu/common.c |  105 ++++++++++++++++++++++-------------------
  arch/x86/power/cpu_32.c      |   41 +++++++++-------
  2 files changed, 79 insertions(+), 67 deletions(-)

 Ciao,
                Paolo
