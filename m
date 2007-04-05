Return-Path: <linux-kernel-owner+w=401wt.eu-S2992577AbXDEMNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992577AbXDEMNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 08:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992692AbXDEMNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 08:13:17 -0400
Received: from twin.jikos.cz ([213.151.79.26]:58257 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992577AbXDEMNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 08:13:16 -0400
Date: Thu, 5 Apr 2007 14:13:10 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: IRQ splitting
In-Reply-To: <Pine.LNX.4.61.0704051231280.22282@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0704051412160.31796@twin.jikos.cz>
References: <Pine.LNX.4.61.0704051231280.22282@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007, Jan Engelhardt wrote:

> My question is whether it is possible that eth0's interrupts go to CPU0 

Documentation/IRQ-affinity.txt

-- 
Jiri Kosina
