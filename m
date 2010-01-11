Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358Ab0AKMuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab0AKMuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026Ab0AKMt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:49:59 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:63614 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab0AKMt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:49:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y+2Z8vSyzBPuD093GiFG+GpikbnZeznlmVXJRx+v08n8PQWJXn3x8TLSRJCNvxJqdr
         0aaToLw1EN0TErx41zJCIL0lfu0R8sXyuxxM7ksISRLHrsFcFT/q0XDbccOd/TNYjsgA
         C2Rtd11HXPWTxxsxSP7VC3pzs+lu8JMFHUx/I=
MIME-Version: 1.0
In-Reply-To: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
Date: Mon, 11 Jan 2010 13:49:54 +0100
Message-ID: <b170af451001110449w134af1f9we804205a5febcaca@mail.gmail.com>
Subject: Re: 2.6.33-rc3-git3: Reported regressions 2.6.31 -> 2.6.32
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/10 Rafael J. Wysocki <rjw@sisk.pl>:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14747
> Subject         : bisected 2.6.32 regression: synaptics touchpad doesn't work
> Submitter       : François Valenduc <francois.valenduc@tvcablenet.be>
> Date            : 2009-12-06 11:16 (36 days old)

Not sure if this is hackish or not, but some patch exists.

-- 
Rafał
