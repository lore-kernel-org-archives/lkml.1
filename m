Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbYBFOAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbYBFOAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 09:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYBFOAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 09:00:09 -0500
Received: from trashmail.net ([213.155.82.90]:48667 "EHLO trashmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbYBFOAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 09:00:08 -0500
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Feb 2008 09:00:08 EST
Message-ID: <47A9BC06.4060604@trashmail.net>
Date: Wed, 06 Feb 2008 14:54:14 +0100
From: Mika Lawando <rzryyvzy@trashmail.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: What is the limit size of tmpfs /dev/shm ?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kernel Users,

is there a size limit for tmpfs for the /dev/shm filesystem?
Normally its default size is set to 2 GB. Is it possible to create a 2 
TB (Terrabyte) filesystem with tmpfs?
Or is there a maximum size defined in the linux kernel?

-- 
Best regards,
Mika Lawando


