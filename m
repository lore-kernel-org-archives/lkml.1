Return-Path: <linux-kernel-owner+w=401wt.eu-S1761020AbXJPCMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761020AbXJPCMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 22:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbXJPCMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 22:12:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:34318 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbXJPCMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 22:12:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=j5LyFGJKRbb6H2uIL8Ip4lgjQab8NTDvH3TL6oJ7WmtdwZEXtl//cEsb2cIcQVrSJ4EERulSj3qAifnKw2v4GqeRXeRaCvu0c6Bp1cpkbTpQclSwqSvV3NR06uBXV/NrxSXx72fyRHOMLhq2ip1+y6vtzhSxWT9VjPZGQLZPk+g=
Message-ID: <86802c440710151912n3b288dc4na06a9abb2addacf4@mail.gmail.com>
Date: Mon, 15 Oct 2007 19:12:07 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: nmi_watchdog on x86_64
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

just found my on hand ck804, and mcp55 based AMD servers:
nmi_watchdog=1 doesn't work
but nmi_watchdog=2 does work

=1, it say: IOAPIC 8259A virtual wire mode...

Did nmi_watchdog=1 work on any other amd64 platform?

YH
