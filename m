Return-Path: <linux-kernel-owner+w=401wt.eu-S934329AbZJMULf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329AbZJMULf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934321AbZJMULd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:11:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:16093 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934317AbZJMULb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject;
        b=D+AZkT19dXhy/og6X1AUsU2HkyfI4nfJi2QvQnsDm0yC8M4n2tIPY+luPOQVjdm1RX
         mSfBfxzxZM+/PG+Bkbw0RxHaQPoJOmonpdlaDiADc49qQsz3W4r1nFpz0pNa+n6F3zay
         TLb5XDCGCGTpIh7E0eui+F9rj7CiT0BSdA0Uc=
Message-Id: <20091013200702.019870576@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 14 Oct 2009 00:07:02 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu
Cc: x86@kernel.org, yinghai@kernel.org, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [patch 0/3] x86 apic series
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is apic NOOP splitted and one show-lapic (Yinghai
suggested it and implemented initial version, so I add
Suggested-by tag there).

Please review. And of course it should be widely/strongly
tested.

Any complains are welcome!

Cyrill
