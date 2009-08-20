Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbZHTBGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbZHTBGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 21:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZHTBGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 21:06:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:3637 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZHTBGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 21:06:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=BiUf08tnbet2XE5l0yLoeLsMOe5A+ZN9CQurTX/CUHZ1Xzn0Vm1nba0Hct3YDLI7QQ
         l+B878vHAWlmSkCTWo9VrxirQB4ywwkFPIpuyNCe37hKo1rpMq0vBXDVlmjyCpzxVYMK
         aroS0cWMvS42fFo/pJrXhuChE5CjaRralneNg=
Date: Thu, 20 Aug 2009 13:06:48 +1200
From: Kelly Bowa <kelly.bowa@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Atom processor inclusion
Message-ID: <20090820130648.6e7236f7@titus>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Any ideas if the Atom CPU patch mentioned here
http://groups.google.ca/group/fa.linux.kernel/browse_thread/thread/26d61febdf354055/a0b4c902e41b5fbf?hl=en&ie=UTF-8&q=config_mcore2+atom
has been submitted/considered for mainline inclusion. AFAIK GCC 4.5
*should* contain the architecture specific code.
