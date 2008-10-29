Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbYJ2OkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbYJ2OkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 10:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbYJ2Oj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 10:39:59 -0400
Received: from gw.goop.org ([64.81.55.164]:44157 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbYJ2Oj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 10:39:58 -0400
Message-ID: <490875B2.1000908@goop.org>
Date: Thu, 30 Oct 2008 01:39:46 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: What happened with __acpi_map/unmap_table?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd thought we'd come up with a suitable set of patches to properly 
implement __acpi_map_table with early_ioremap, and a corresponding 
__acpi_unmap_table.  Did they get dropped somewhere along the way?

    J
