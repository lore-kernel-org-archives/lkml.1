Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbZJKJxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbZJKJxe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 05:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbZJKJxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 05:53:30 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:61998 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbZJKJxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 05:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=uscLWULoJqs3ouuz7ug+BqKScMwPtML4TEvYg+rmgeotEd0cnChupadyhlC97vPbrZ
         Sn5q84l5VUIai75eDV0X1PG2gZd6okOh2gFUFo40cLGdHaSbFS+Dn76z5wuGVBqJSa55
         sUPMmjM0sBfR4mp1QK9PUkAYfssC1kbRl6GAg=
Date: Sun, 11 Oct 2009 17:52:18 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de
Subject: NOHZ: local_softirq_pending 08
Message-ID: <20091011095217.GA2200@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

With kernel 2.6.32-rc3-00052-g0eca52a I got following KERN_ERR
messages just while using firefox:

[  130.527399] NOHZ: local_softirq_pending 08
[  130.559807] NOHZ: local_softirq_pending 08
[  130.835292] NOHZ: local_softirq_pending 08
[  130.854630] NOHZ: local_softirq_pending 08
[  130.892045] NOHZ: local_softirq_pending 08
[  130.893276] NOHZ: local_softirq_pending 08
[  130.912109] NOHZ: local_softirq_pending 08
[  130.928032] NOHZ: local_softirq_pending 08
[  130.938503] NOHZ: local_softirq_pending 08


Any idea? or known issue?

--
Regards
dave
