Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbZHYSfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbZHYSfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbZHYSfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:35:17 -0400
Received: from mail.electro-mechanical.com ([216.184.71.30]:54323 "EHLO
	mail.electro-mechanical.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154AbZHYSfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:35:16 -0400
X-Greylist: delayed 1307 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Aug 2009 14:35:16 EDT
Date: Tue, 25 Aug 2009 14:13:30 -0400
From: William Thompson <wt@electro-mechanical.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel stops booting.
Message-ID: <20090825181330.GA17132@electro-mechanical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please keep me in CC.  I'm not on the list.

I have a computer which is not booting all the way.  The kernel is v2.6.27. 
Last 3 lines:
ENABLING IO-APIC IRQs
.. TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Celeron(R) CPU 2.00GHz stepping 09

The CPU0 line is where it hangs.  I'm sure it's a hardware problem as
ubuntu's live cd doesn't work either.  I just wondered if anyone could give
me some clue as to what the problem may be.

Please keep me in CC.  I'm not on the list.
