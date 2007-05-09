Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbXEISCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbXEISCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbXEISC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:02:26 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:63743 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbXEISC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:02:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=M4tZ6TrJEJ08C4BMwF3SXP3qaBAzM/CcCkjyXSzcAZeHHpaTcIKrHxtwldvATlXBLfti0QU2udgBQosVkfrILC3bcM5/hz1RYUA/oE8dsJeZsen5vJoPZ10802lB81nMBE6DcGMaOuVESr7PaJlcVZH2jF0Ivq7dT9aglEGo4Pc=
Message-ID: <5d96567b0705091102j7168620fu8476e7756a8d8b5f@mail.gmail.com>
Date: Wed, 9 May 2007 20:02:24 +0200
From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: hpet on hp proliant dl380 g5 4 cores
Cc: robert.picco@hp.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Robert.
I have noticed that you are the writer of the hpet driver in linux.
I have been running the test tool provided in
linux/Documenration/hpet.txt  on an hp dl380. It runs for few seconds
and then the hpet timer clock stopped interrupting ( I looked at
/proc/interrupts). It happens faster when i increased the frequency
(starting from 1000 to 16000) . But is always happens.

Do you why ?

Thank you
-- 
Raz
