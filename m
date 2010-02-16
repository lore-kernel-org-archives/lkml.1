Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab0BPDfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 22:35:32 -0500
Received: from n4-vm0.bullet.mail.gq1.yahoo.com ([67.195.9.7]:40628 "HELO
	n4-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932530Ab0BPDfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 22:35:30 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 321666.36153.bm@omp130.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=yZ8rA0eZw3EBbOR3jaP/cZCl7O7zAKgM0gwXdKcvJ5a5I6x1Yd2jqErRmzzTJkHHlUOewk45DiNF5GDwyDuh/EpTiumpMrBWDPgv/Zrqzbu6Z5lcLhGzVFToe301GBAqzFuYVuiHKVxSsbBextwXCZzP02VpzcbFwbPfgmo+4ss=;
Message-ID: <123540.36996.qm@web112508.mail.gq1.yahoo.com>
X-YMail-OSG: vjau0sMVM1l3WaC7bSMAvWBV2oSx.qQRADZHdUgxMzbH30Ks7_88WA.tDKbRF2MmsWhlFgRI2eAFDXeNtA4ZgNvKaJFcN_MXxxQEiRK1Bh_aoxHk7H.hBot7Ey__Yd15zSlyPkmBqIOVjb2AFHiHYORELtD58VpV6M0y3pfFSAemfRveLr7b.2Mz3Pbc8IzpBvi5.Fz1RlwSTgDfhb5FWG5q8ZXYVWZxPLCxwrYFZVtpNv1pAKdPHLJECwMHK0_Z_lLeYFEGWX4hUhfocRg3Zo_2RfKFxMonJt3jqfXJNpwEocu7DKkwTq12..A2JQiOfoP6my0u6xThPsJ6zorVxrPoLbzE4z3QhUrJmzC1r2eiyJZrSyiOkQ--
X-Mailer: YahooMailClassic/9.2.12 YahooMailWebService/0.8.100.260964
Date: Mon, 15 Feb 2010 19:35:30 -0800 (PST)
From: Naveed Cochinwala <naveed_coch@yahoo.com>
Subject: undefined reference to `.L1485'
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I try to compile the latest stable kernel (2.6.32.8), here is the error I get
~/linux-2.6.32.8/include/trace/events/kmem.h:47: undefined reference to `.L1485'

Some info on my existing environment/machine:
The kernel that I have installed on my machine is: 2.6.9-42.EL
x86 machine.
gcc (GCC) 3.4.6 20060404 (Red Hat 3.4.6-3)


Please email responses to my private email: naveed_coch@yahoo.com.

Naveed Cochinwala



