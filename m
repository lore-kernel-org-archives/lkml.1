Return-Path: <linux-kernel-owner+w=401wt.eu-S933937AbZLPNjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937AbZLPNjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 08:39:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933851AbZLPNjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 08:39:06 -0500
Received: from snt0-omc1-s17.snt0.hotmail.com ([65.55.90.28]:22912 "EHLO
	snt0-omc1-s17.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933849AbZLPNjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 08:39:05 -0500
X-Originating-IP: [94.195.177.167]
X-Originating-Email: [johnkyr83@hotmail.com]
Message-ID: <SNT111-DS22852E1482A35ACA2002DA7870@phx.gbl>
From: "Ioannis Kyriakopoulos" <johnkyr83@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: LAPIC kernel and update_process_times() 
Date: Wed, 16 Dec 2009 13:38:54 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acp+VRxWWvj3VSY7SD2x3hIFLiXzzA==
Content-Language: en-gb
X-OriginalArrivalTime: 16 Dec 2009 13:39:02.0325 (UTC) FILETIME=[20EDB650:01CA7E55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have configured a uniprocessor kernel with LAPIC enabled. My problem is
that I can't find out where the update_process_times() is called. I was
expected to be called from the smp_apic_timer_interrupt() or
local_apic_timer_interrupt() but I can't find it there.

Thanks a lot.

P.S. please CC me.

