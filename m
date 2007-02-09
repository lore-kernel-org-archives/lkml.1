Return-Path: <linux-kernel-owner+w=401wt.eu-S1946028AbXBIC5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946028AbXBIC5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 21:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946029AbXBIC5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 21:57:52 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:51506 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946028AbXBIC5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 21:57:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QVDlAh0KuBeVs6OaySLwBaCHllI1s0agHEBYezPtMwpnwnkuLNkv51ogb34heqGg5EO6BHz2Vbbv9TvOQk7uCpOpHtVFX0nVoHsICw6l+ZFmnKyIBIovIZCDqOqGA9ovLa6H+46GXM3Gwdhfl3w0QestAG2GvWluLrbbDpHy63Y=
Message-ID: <82e4877d0702081857u273df895n5df617a14da8caa0@mail.gmail.com>
Date: Thu, 8 Feb 2007 21:57:50 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: akpm@linux-foundation.org
Subject: -mm merge plans for 2.6.21
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>x86-fix-vdso-mapping-for-aout-executables.patch
>a.out executables are presently non-functional.  This patch needs more work.

I have a patch for x86 ready and tested and I should be able to get
the full thing (x86, ppc, sh and x86_64) out over the weekend. (This
time around I got rid of the CONFIG stuff used __attribute__((weak))
as Andi suggested. Hopefully that's what you meant by more work?)

Parag
