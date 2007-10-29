Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbXJ2OJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbXJ2OJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXJ2OJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:09:44 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:29679 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbXJ2OJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PKXa/JY8vNCu0N5n2tCvrKLpb68Hhaq9ffZxCN5K0HLBJy+YTlBp0FFT3NguhSzQF5tIQsyb+3OWZUGGydd6P2Rac1LK6M8/Avg2W6tvun4UobSAQXEmdY1ZFR+MnWAr6vqxJEHc8NVk2HWmytwuG4/5uTsvnUZyj1brBpSHsJE=
Message-ID: <9c21eeae0710290709x527cf4fcq52bb410907ff496@mail.gmail.com>
Date: Mon, 29 Oct 2007 07:09:33 -0700
From: "David Brown" <dmlb2000@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net
Subject: 2.6.23.1-rt4 and kvm 48
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uhm, not sure who to send this too...

I thought I'd try out the realtime patch set and it didn't work at all
with kvm. The console didn't dump anything and the system completely
locked up.

Anyone have any suggestions as to how to get more output on this issue?

It got to the point of bringing up the tap interface and attaching it
to the bridge but that was about it for the console messages.

Thanks,
- David Brown
