Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbXD0Opi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbXD0Opi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbXD0Oph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:45:37 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:11729 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbXD0OpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:45:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Qna8aO+ZQC2vn0fqZbOrj/bMnc4o+pejvCtaaNX5Z5jCt7RwUHUOpcGBZmf74bRNTrilOaaZsmFCMQiHION//dU2tN+8wFnCNOORr74qa/bczZP3YxTy7RldDtLMyu5fwyLLEzYH684IM4UrTvh7EH+OoIlStT/ObsTZovtF9fc=
Message-ID: <8355959a0704270745i2c0b295u4185c7ac63503696@mail.gmail.com>
Date: Fri, 27 Apr 2007 20:15:16 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Enigma of Hardware Monitoring in 2.6.20.x or 2.6.21
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am did compile those kernels to the best available hardware in a
P-III machine. (Research experiment - P-III box is a part of Wireless
stuff).

I have this enigma called Hardware Monitoring support on many boards. Because:

a) Vendors don't give enough info - which chips are meant for Hardware
Monitoring in a particular board, say in this case a P-III 810E or P4
945 or Core2Duo 965/975 boards.
b) Unfortunately, there isn't any reference available in the Config to
select the chips for the respective boards. Example - for 810E - some
x chip is to be enabled in that tree.

How to solve this problem? How to know in Linux (any commands) whether
H/W Mon is supported by 810E board or 945 board? (apart from digging
from the manuals to narrow down the problem).

I am willing to do something for this task (volunteer). Comments?

~Akula2
