Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbZHCWNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbZHCWNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 18:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZHCWNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 18:13:41 -0400
Received: from cssun.mathcs.emory.edu ([170.140.150.1]:52596 "EHLO
	cssun.mathcs.emory.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbZHCWNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 18:13:41 -0400
X-Greylist: delayed 2123 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Aug 2009 18:13:40 EDT
Message-ID: <4A77585E.6020307@mathcs.emory.edu>
Date: Mon, 03 Aug 2009 17:36:30 -0400
From: Ken Mandelberg <km@mathcs.emory.edu>
User-Agent: Thunderbird 2.0.0.6 (X11/20070820)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Panic with 2 quad opterons (2346)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been trying to upgrade a box that had two dual opteron, to two quad 
opterons (2346). The motherboard and firmware is documented as 
supporting this.

I've tried the latest Ubuntu and Centos distributions.

With 32 bit  kernels, the two quad cores work fine.

With 64 bit kernels, and only one quad core inserted it works fine.

With both quad cores, the 64 bit kernels panic immediately.

In all tests there are 4 2GB dimms , 2 in each in bank.

Any thoughts?

Please cc me directly on any response.

Thanks!

