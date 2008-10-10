Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYJJGK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYJJGK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 02:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYJJGKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 02:10:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:39082 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYJJGKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 02:10:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:x-mailer:content-type:content-id
         :x-msmail-priority:x-priority:date:message-id:mime-version
         :content-transfer-encoding;
        b=heKC+S/k+j5fX0joAGBE8FfD0JuchfyFoW/P7SzG5S44wzRKGyQHhs/xL2Um723AXh
         lorPlWWYJdSs+M8kYrWLMBbihbjJ82nKijStG5lWiBLYPZjM8uJX8JbbstrJFqMyR8zo
         BetW83sZ6CvzKFPYGXMZA9gFFugR/yyrY/HBg=
From: Luca <luca.ognibene@gmail.com>
Reply-To: Luca <luca.ognibene@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel hangs with two frame grabber card
X-Mailer: Modest 1.0
Content-Type: text/plain; charset=utf-8
Content-ID: <1223618951.4656.1.camel@Nokia-N800-23-14>
X-MSMail-Priority: Normal
X-Priority: 3
Date: Fri, 10 Oct 2008 08:09:12 +0200
Message-Id: <1223618952.4656.2.camel@Nokia-N800-23-14>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi! i've a problem.. if i use two (noname) pci frame grabber cards (each card has 4 bt878 chips) my system hang after a while (a day or even less if i add a lot of cpu load).

has anyone heard of something like this? what i've tried is this:

- if i use only a single card the system works fine (tested for days)

- tested a lot of kernel versions (latest tested is 2.6.26)

- tried different motherboards.. same problem. right now i'm using a p5kpl-vm mb

- tried to disable acpi/apic/smp(ht) but nothing change..

any idea on how to debug further? 

thanks for all your work!

Luca
