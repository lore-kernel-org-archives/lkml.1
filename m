Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbYCZPlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbYCZPlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbYCZPlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:41:31 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:38275 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbYCZPla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:41:30 -0400
Date: Wed, 26 Mar 2008 16:41:17 +0100 (CET)
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: linux-kernel@vger.kernel.org
Subject: disabling MDI-X for via-rhine card?
Message-ID: <alpine.LRH.0.9999.0803261615410.2535@linuxbox.linuxbox.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Antivirus: on proxybox by Kaspersky antivirus, engine 5.5.10, data 596733 records(26-03-2008)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
is it possible to somehow disable MDI-X on via-rhine cards? I have board 
with three VT6105M chips, and I unfortunately need to disable MDI-X. By 
looking into source of via-rhine it doesn't seem to be possible, does 
anybody have a tip how this could be setup? Even some tip for needed 
register changes could help, anything....
Thanks a lot in advance
with best regards
nik


-- 

