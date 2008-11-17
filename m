Return-Path: <linux-kernel-owner+w=401wt.eu-S1752212AbYKQMx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbYKQMx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 07:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYKQMxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 07:53:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:45468 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYKQMxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 07:53:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bpJwB/SBZWhoqDEirEx7XEbb8FbLOALVhVAmFc6gkd5ww7kQTVOrXAYqqHZ2ENsf7U
         JYlagTBpLkrF3yRKDLbyPVvbvaYQ/Pk1AfuOXuS2fn3ASMuPKbr2Nvz9CrH/SnEOUIVP
         QFVa1/Mj/Ug3wZtdiCG6rxjAjWc8LrhECOtP8=
Message-ID: <ab4346860811170453i2bba95a6nb16c2c9e59424272@mail.gmail.com>
Date: Mon, 17 Nov 2008 14:53:49 +0200
From: "Victoria Muntean" <vikimun@gmail.com>
To: "Kernel Linux" <linux-kernel@vger.kernel.org>
Subject: size of swapped-out part of the process
In-Reply-To: <ab4346860811170452t2cbcb451u407edca19c9e0ba6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab4346860811170452t2cbcb451u407edca19c9e0ba6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How can I calculate size of swapped-out part of the process from
/proc/PID/*, even if approximately ?
For example, I have VmSize=1216192 kB, VmRSS = 628788 kB, but global
swap-in-use==0.
Hence (VmSize - VmRSS) is far from being swapped-out part of the
process. What is ?

Thanks
Viki
