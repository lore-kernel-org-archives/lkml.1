Return-Path: <linux-kernel-owner+w=401wt.eu-S1764289AbZDHVHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764289AbZDHVHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 17:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759664AbZDHVHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 17:07:14 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36883 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759156AbZDHVHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 17:07:13 -0400
Date: Wed, 8 Apr 2009 14:07:08 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: mingo@elte.hu, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       x86@kernel.org
Cc: linux-kernel@vger.kernel.org, garyhade@us.ibm.com, lcm@us.ibm.com
Subject: [PATCH 0/3] x86/x86_64: fix IRQ interruption issues
Message-ID: <20090408210708.GB11159@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These fixes seem to be working well on the IBM x460 and x3835.
I still need to test them on more of our systems but since I am
fairly new to the I/O APIC code I wanted to get more eyes looking
at the changes to make sure that I am at least on the right track.

If any of the I/O APIC experts out there have any ideas on how
the problems can be better addressed, please let me know.
Any testing would also be appreciated.

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

