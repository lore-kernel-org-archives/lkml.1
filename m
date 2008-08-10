Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbYHJA1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbYHJA1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 20:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756483AbYHJASL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 20:18:11 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:23631 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260AbYHJASJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 20:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=we5JjntMM3ykVEM89WyZQwQDwfuxqT/OkIbWYqPpzq1PGgzhXyg+vuDxZv1Y39jDR0
         Br5YX/mfTeQyFHcwnHR/qoluTHgK5w7Om3L8+s2DTkmGrGaGWY8P9GYj8t4IkZ7za7gt
         ylTSS6AIXsJGAg8Hphqck1QAyc+SUf0TcXHuI=
Message-ID: <489E341F.2030809@gmail.com>
Date: Sat, 09 Aug 2008 20:19:43 -0400
From: Bradley Hanna <brahan.ml@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Programming the apic when no external to cpu timer is present?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am working with an embedded testing board that has no timer external
to the cpu other than an rtc.  How does linux go about programming the
local cpu timer (apic) to raise hardware interrupts?

thanks for your patience,

brahan
