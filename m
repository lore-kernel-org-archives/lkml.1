Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbXG1Rz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbXG1Rz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 13:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbXG1Rzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 13:55:51 -0400
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:46518 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954AbXG1Rzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 13:55:50 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Avi Kivity <avi@qumranet.com>
Subject: 2.6.23-rc1, KVM-AMD problem
Date: Sat, 28 Jul 2007 18:55:41 +0100
User-Agent: KMail/1.9.7
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707281855.41277.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm getting periodic oopses running KVM-33 on 2.6.23-rc1. Here is a digital 
photo of the oops. Alarmingly, a lot of the time it triple faults the machine 
and I don't get a chance to grab it. This time I was lucky, though.

http://devzero.co.uk/~alistair/kvm-2.6.23-rc1.jpg

Unfortunately, some of the oops text scrolled out of the screen. I will 
endeavour to reproduce the bug over serial console, but I can make no 
guarantees.

The CPU is an AMD X2 BE-2350, chipset is AMD 690G.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.

