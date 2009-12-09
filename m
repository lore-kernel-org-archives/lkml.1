Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbZLIQCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbZLIQCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 11:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZLIQCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 11:02:20 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:37956 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbZLIQCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 11:02:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=GxFQ4HHOjvOjKjD3q5ul7JJBu2iD61Fel4z3tnmJnPU2/8R502HI5ejV1jpygQNBbF
         sswpbu5uC7S5/YVa4bZug0nl/5qfM/MzJgdER6t2HE39qp2ZBKT4VQ+FDd5scJuUQMIY
         GWpXKqWWP4QHiKU8PNkuz37orD7Qd1jgHsmLc=
MIME-Version: 1.0
Date: Wed, 9 Dec 2009 18:02:25 +0200
Message-ID: <82cfbe860912090802q34b6aa84yc69b32bb7b0c435f@mail.gmail.com>
Subject: CPUfreq deosn't change the current frequency
From: tarek attia <tarek.m.attia@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

CPUfreq doesn't work,,I downloaded the PM Linux kernel ,and enabled
the CPUFREQ driver before compilation .

However every writting in the scaling_setspeed doesn't get any
return,,doesn't change the frequency however without errors .

Any Idea??

-- 
tarek
