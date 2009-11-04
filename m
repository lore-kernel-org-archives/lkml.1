Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbZKDWAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbZKDWAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 17:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758235AbZKDWAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 17:00:52 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:37253 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbZKDWAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 17:00:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=s2SBRuN3EQd+UCJWCk1AXbKU+mUZHHuA7YFzxqlhEgSQK4KtOUiq4jy+XHi77eIizj
         OyCGFp2vYlHkvw3oshg69K1/42yKZWNOiGys/pqKbk1UEYsAWnwN8VTlPbt7yQ7hnZwh
         /TELI54nG9xJHIU+1iq49q6KVhJNSCee2gXr0=
Date: Wed, 4 Nov 2009 17:05:42 -0500
From: Michael Gilbert <michael.s.gilbert@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: CVE-2009-2584
Message-Id: <20091104170542.e40b12ec.michael.s.gilbert@gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

CVE-2009-2584 [0],[1] has been disclosed for quite a while now (with
existing exploit code by Brad Spengler [2]).  A patch has also been
available for the same amount of time [3], but as of 2.6.32-rc6 it is 
still not applied.  Did this slip through the cracks?  Thanks upfront
for any info on the matter.

Best wishes,
Mike

[0] http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2009-2584
[1] http://xorl.wordpress.com/2009/07/21/linux-kernel-sgi-gru-driver-off-by-one-overwrite/
[2] http://grsecurity.net/~spender/exploit_demo.c
[3] http://lkml.org/lkml/2009/7/20/348
