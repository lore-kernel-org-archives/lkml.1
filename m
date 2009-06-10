Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbZFJIW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbZFJIW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbZFJIWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:22:13 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:10882 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbZFJIWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:22:11 -0400
X-RZG-AUTH: :I2ANY0W6W/eA95XfH/xfO6gOxLxTty/udEMngcJ/VAKW226lDNJVyuYFLDI2PNQ=
X-RZG-CLASS-ID: mo00
Message-ID: <4A2F6D32.8030400@hartkopp.net>
Date: Wed, 10 Jun 2009 10:22:10 +0200
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: patchwork@ozlabs.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] can: af_can.c use rcu_barrier() on module unload.
References: <20090608130959.10052.54590.stgit@localhost>	<20090608131138.10052.5408.stgit@localhost>	<4A2D112A.4000308@hartkopp.net> <20090610.011027.43904351.davem@davemloft.net>
In-Reply-To: <20090610.011027.43904351.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Oliver Hartkopp <oliver@hartkopp.net>
> Date: Mon, 08 Jun 2009 15:24:58 +0200
> 
>> Acked-By: Oliver Hartkopp <oliver@hartkopp.net>
> 
> Please don't capitalize the "By" in "Acked-By".

Sorry.

> Otherwise
> patchwork doesn't pick them up automatically.

IMHO patchwork should be robust against these type of typos and convert them
for the users (== your) convenience into 'Acked-by:' ...

Regards,
Oliver

