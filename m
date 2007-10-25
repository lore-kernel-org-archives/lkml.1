Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbXJYDCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbXJYDCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbXJYDCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:02:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:36661 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbXJYDCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:02:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=CbvkivAQ77YGcRAteglP/1MTttirfD8IsVBfZTbviniD0cmLg/KqP4LlijxbRbpqAy2wKf7wQ1YWN2tVzoeMAj2b1XuIGIY2clUOS8NHc/5d9qslkqZsLHmThJzVIfwbDCU5XUJTLgaDtxnR13bbH4TsKOESKbLX+w5oFlVGEk0=
Message-ID: <2ed59cbb0710242002r7ff3ab89k2b22582fc1de9d2c@mail.gmail.com>
Date: Wed, 24 Oct 2007 23:02:14 -0400
From: "Zurk Tech" <zurktech@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Quad core CPU detected but shows as single core in 2.6.23.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,
I have a tyan s3992 h2000 with single barcelona amd quad core cpu (the
other cpu socket is empty). cat /proc/cpuinfo shows amd quad core
processor
but core : 1....ive compiled the kernel from scratch with smp and
amd64 + the numa stuff. i also tried debian etchs amd64 smp kernel and
same result.
is amd barcelona quad core cpu not yet supported or is it something else ?
Thanks for any insight. im completely stumped. ive dealt with
mutliprocessing machines before and have a couple of dual cores which
are fine with the
exact same kernel configs. my amd tk-53 x2 turions show 2 cores in cpuinfo....
-Zurk-
