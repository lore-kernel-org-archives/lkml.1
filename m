Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbXGANzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbXGANzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 09:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbXGANz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 09:55:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:34841 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbXGANz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 09:55:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:organization:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=Pks2VfQuYNfl0BtxR72vViiCTm4RP2NvTaSwtobgTemRbAAaubffCYGwMCUXIj/TxkyzagkPKR9bhtZ4+qlEf4ep3bIcZ5hcls37yD6mfUDXVkYy90G2HNkTAJGFnfKtnxg3augnxPlAC9b/zT3EMYz/vl8aWNLQGG6/D4WAPrY=
Message-ID: <4687B247.8000306@gmail.com>
Date: Sun, 01 Jul 2007 15:55:19 +0200
From: Patrizio Bassi <patrizio.bassi@gmail.com>
Reply-To: patrizio.bassi@gmail.com
Organization: patrizio.bassi@gmail.com
User-Agent: Thunderbird 2.0.0.4 (X11/20070619)
MIME-Version: 1.0
To: "Kernel, " <linux-kernel@vger.kernel.org>
Subject: sky2: keep the interface up and working
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm using vmware and bridged networking with interface eth1.

The brigde works only when eth1 has the physical connection enabled, so
i always need to have another pc running.
with tcpdump i can see packets coming from virtual machines, but none
sent back.

I wonder if it's possibile to have the interface always "alive" (as
ifconfig reports it up) in order to have the bridge working.
I looked for some ethtool options...but nothing...

thanks for support

Patrizio

