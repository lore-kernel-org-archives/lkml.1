Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZLBOkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZLBOkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:40:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZLBOkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:40:03 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:24693 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZLBOkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:40:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=nhpc2Eyn/jpJ9KJabazRyR0OEhFIpwmJ8vVKFmOeGyNkdQwZIjQqGseG4lvcVFNsUv
         k3iyWey8viy9NBh1d/Rn/5Dsk58atvsSoTfD9Cf12XAMPwwy7cRsdywfIfUuqDcFgjrw
         HQeCvKijI28GEB2bWvMx1RV1P70XSCKrjktek=
Date: Wed, 2 Dec 2009 09:45:39 -0500
From: Michael Gilbert <michael.s.gilbert@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: CVE-2004-2135 and CVE-2004-2136
Message-Id: <20091202094539.c1184899.michael.s.gilbert@gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

CVE-2004-2135 [0] and CVE-2004-2136 [1] were disclosed over five years
ago; however, i have been unable to verify whether they have been fixed
or not in the latest kernels.  The paper [2] indicates that the
disclosing team developed a 3,000 line patch, but I have been unable to
track this down to determine whether or not it has been applied.  There
is also this more current write-up [3], which is rather revealing.  Have
these issues slipped through the cracks?  Thanks upfront for any info on
the matter.

Best wishes,
Mike

[0] http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2004-2135
[1] http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2004-2136
[2] http://mareichelt.de/pub/notmine/diskenc.pdf
[3] http://mareichelt.de/pub/texts.cryptoloop.php?alt_styles=2
