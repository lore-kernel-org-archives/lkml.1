Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbYBQPUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbYBQPUK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 10:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756466AbYBQPT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 10:19:56 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:31547 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbYBQPTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 10:19:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:subject;
        b=TZ47WQxJmhQ9h19KoAYEukHH1g1nvzeWiwR3E31F4Po8OnI/XBMct9cru24VrllaeDoEvvNuUal2g3ADDE3bNxltDlyXbNU4+2udJb4SWyYWykvKcyPPwUy+lAJrvY9VJkYsjrqBMKHote2tdOps3fczkVBxdgy5fVUf4Q+xkeM=
Message-Id: <20080217151716.274134094@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 17 Feb 2008 18:17:16 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: ak@suse.de, mingo@elte.hu, sam@ravnborg.org, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [patch 0/2] x86: vmlinux.lds cleanup 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series replaces numeric constants in vmlinux.lds scripts
to appropriate symbolic names.

Any comments are highly appreciated.

-- 
