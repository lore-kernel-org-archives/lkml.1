Return-Path: <linux-kernel-owner+w=401wt.eu-S935896AbXJSRcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935896AbXJSRcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761967AbXJSRbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:31:44 -0400
Received: from [12.38.223.190] ([12.38.223.190]:3163 "EHLO
	mail.sw.starentnetworks.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764994AbXJSRbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:31:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18200.59881.915314.565911@zeus.sw.starentnetworks.com>
Date: Fri, 19 Oct 2007 13:31:21 -0400
From: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: fix TSC clock source calibration error
In-Reply-To: <1192740214.17527.185.camel@imap.mvista.com>
References: <18196.53154.100115.92459@zeus.sw.starentnetworks.com>
	<1192740214.17527.185.camel@imap.mvista.com>
X-Mailer: VM 7.17 under 21.4 (patch 17) "Jumbo Shrimp" XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker writes:
> Can you tell us what type of machine this was? I've seen complaints
> where the SMI's can cause some other funny stuff with calibration , be
> no one can every reproduce anything..

Xeon LV (Sossaman) based custom board. BIOS is GenSW.

-- 
Dave Johnson
Starent Networks

