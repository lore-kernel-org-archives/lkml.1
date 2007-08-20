Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbXHTJyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbXHTJyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 05:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbXHTJyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 05:54:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:1273 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbXHTJyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 05:54:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=SecCvLis8WiObSivJabq/YQGD6lfnFDmo8zj1UFDQf4flv/Ka8zvm2tUIIA9sVzA1/DdiRLGu6uLN9o/Gqj7W72BXkZJo1f2OMClF72ap97YGaEzcpz/a2w65zs6DIgIp3xbfGboFemt00n5TD0heQCHc7jvkzDZ/bpZ0DbQbSM=
Message-ID: <ab40e9c0708200254n1ac0bef5j28ec2e24358b8aa3@mail.gmail.com>
Date: Mon, 20 Aug 2007 11:54:34 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: realview_timer_interrupt( ) problem
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I am running the kernel 2.6.21 on my realview_eb system

I got problem at the realview_timer_interrupt():
this interrupt routine is executed 4 times, during one os timer interval.
which means even the real interrupt doesn't happen, the interrupt
routine is still executed.
anyone have any idea where might be the problem?

I have tried a lot but still no idea.

regards,

Yang
