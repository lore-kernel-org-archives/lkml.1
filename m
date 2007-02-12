Return-Path: <linux-kernel-owner+w=401wt.eu-S965036AbXBLRto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965036AbXBLRto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 12:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965038AbXBLRtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 12:49:43 -0500
Received: from asphyx.net ([82.168.54.189]:4752 "EHLO esther.asphyx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965036AbXBLRtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 12:49:43 -0500
X-Greylist: delayed 716 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 12:49:43 EST
Subject: Which CPU for VIA C7/Esther?
From: Mark de Vries <mark@asphyx.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: asphyx.net
Date: Mon, 12 Feb 2007 18:37:38 +0100
Message-Id: <1171301858.3557.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been googeling for about an hour now and can't find an answer to:
What type of CPU should I select when compiling a recent 2.6 kernel if I
have a VIA Esther CPU?

Please CC me, I'm not on the list.

Thanks & Regards,
Mark.

~$ cat /proc/cpuinfo
processor       : 0
vendor_id       : CentaurHauls
cpu family      : 6
model           : 10
model name      : VIA Esther processor 1200MHz
stepping        : 9
cpu MHz         : 1200.189
cache size      : 128 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce apic sep mtrr pge cmov
pat clflush acpi mmx fxsr sse sse2 tm nx up pni est tm2 rng rng_en ace
ace_en
bogomips        : 2407.15


