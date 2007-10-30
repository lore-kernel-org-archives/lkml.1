Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbXJ3Hyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbXJ3Hyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 03:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbXJ3Hyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 03:54:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:61972 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbXJ3Hye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 03:54:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Z1FgrxJDR8cty5mUYbWdDcc0tsQKg4aJyr9Q0Ro5MVKoCKz5B33EoMEa1Qc5IYowmKBtjCg+4NHwzE/UmhKkz0rSjeU50Ygs3uoncobnOyfOOzvSNH1jL5Ae9O0sNRgZzLpv+W2LXob9jK+BCpv77VPJURMoDdkrYOlenavx+s8=
Message-ID: <4dcf7d360710300054m7ac77445pf786bd9044b572d7@mail.gmail.com>
Date: Tue, 30 Oct 2007 08:54:33 +0100
From: "Lorenzo Allegrucci" <l.allegrucci@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: 2.6.23 performance regression
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, sorry if this is a faq but reading
http://people.freebsd.org/~kris/scaling/7.0%20Preview.pdf (slides 17,
18)
looks like 2.6.23 is having a performance regression on MySQL and
PostgreSQL benchmarks.  Has anyone investigated these?

-- 
Lorenzo
