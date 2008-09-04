Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbYIDSoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbYIDSoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757671AbYIDSjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:39:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:15553 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859AbYIDSjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=JblwAN9TIAAdlbM/t92XMhtPCNYRUtlkAXCq6iN1SDXrhLfYV6j9chUk5fYz3qXrhC
         B9zrgvX8hErkPz8pfkPym6olTzmT6S9uXRhJKi2z0tSVrLSrC76ITYYsHKPkNR5bBmE8
         qr9XbY+nJTE9jTISfQgVlvWS4lsdM1ALkQYEI=
User-Agent: quilt/0.46-1
Date: Thu, 04 Sep 2008 22:37:48 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       yhlu.kernel@gmail.com, macro@linux-mips.org
Subject: [patch 0/3] -tip/master io-apic small cleanup
Message-ID: <48c02b69.0405560a.6491.7cf6@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  A few cleanups (smallish indeed) over io-apic code.
Please review - comments are (as always) welcome!

		- Cyrill -

-- 
