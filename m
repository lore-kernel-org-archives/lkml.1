Return-Path: <linux-kernel-owner+w=401wt.eu-S1757829AbYCJXOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829AbYCJXOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbYCJXN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:13:26 -0400
Received: from mail.emergencycommunicationsystems.com ([24.123.23.170]:40209
	"EHLO unifiedpaging.messagenetsystems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756500AbYCJXNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:13:25 -0400
X-Greylist: delayed 3367 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Mar 2008 19:13:25 EDT
Message-ID: <47D5B366.8040605@pagestation.com>
Date: Mon, 10 Mar 2008 18:17:10 -0400
From: Jerry Geis <geisj@pagestation.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: centos 5.1 and 2.6.24.3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am using centos 5.1 along with 2.6.24.3 (as I want to use kvm-amd).
All this is working. I think by default this uses the new completely 
fair scheduler.

I want to default back to the old scheduler but compile with 
virtualization.
What option is it in the make menuconfig that is for the old scheduler.

Thanks,


Jerry
