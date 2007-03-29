Return-Path: <linux-kernel-owner+w=401wt.eu-S1030333AbXC2QFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030333AbXC2QFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 12:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030341AbXC2QFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 12:05:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:50358 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030332AbXC2QFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 12:05:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mkpqI7XoSHT21tw4Mupg0ZpzcfHes5wUItbJiQB+hsNfYnr+k/lL18fzCPoJI0g3WqDy7mw0UqQ+IhsoiqZfh6D9r4fWKehVIutN38Jb1iz14l0KB64u+HnQjDt44nPwFA7mlcmks6W/QtoXDYnhCJHXH+E5wq1orfkxgdEPjUc=
Message-ID: <7783925d0703290905u1e4d94f2v88d6f1736c52de81@mail.gmail.com>
Date: Thu, 29 Mar 2007 21:35:13 +0530
From: "Rick Brown" <rick.brown.3@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: regarding kernel preemption
Cc: kernelnewbies <kernelnewbies@nl.linux.org>, linux-newbie@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I had posted this on kernelnewbies, but did not get much response, and
hence trying here.

When we preempt_enable() / preempt_disable(), is the kernel preemption
enabled or disabled for ALL the processors or just the local
processor?

TIA,

Rick
