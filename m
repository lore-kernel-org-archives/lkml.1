Return-Path: <linux-kernel-owner+w=401wt.eu-S1751554AbZJTJJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbZJTJJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 05:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbZJTJJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 05:09:18 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:27424 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZJTJJR convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;3:1>);
	Tue, 20 Oct 2009 05:09:17 -0400
Message-Id: <4ADD9A94020000780001ADBB@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 20 Oct 2009 10:10:12 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: CONFIG_X86_L1_CACHE_BYTES vs. CONFIG_X86_L1_CACHE_SHIFT
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is the reason for having these, under various conditions disagreeing
(see i386_defconfig), but supposedly redundant auto-selected config settings?

Thanks, Jan

