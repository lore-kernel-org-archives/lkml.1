Return-Path: <linux-kernel-owner+w=401wt.eu-S1752027Ab0AZAeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab0AZAeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883Ab0AZAen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:34:43 -0500
Received: from web55005.mail.re4.yahoo.com ([206.190.58.139]:38639 "HELO
	web55005.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751287Ab0AZAel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:34:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=tupesSjaGez9gctYz32FVbTyv5zmWNNxnmkYYg0lkSvzYsBQkkhr8u4lpuSI9rMcQttV1Mr/xYjMexvJn3iEDje9mVOoJth7Ctw9yOS9exvTWIIz3OvVbAj9xNPVpeA5DYdrusjm8Fxvz4MAyqFOEtlGY2GexEzVygsx6v1Z4kI=;
Message-ID: <666103.59126.qm@web55005.mail.re4.yahoo.com>
X-YMail-OSG: ruCFlA4VM1nHVOm6Jf7bRPaT.pJESB6M3XvRlLcw3DVRMGAEBRaKJ2BkK3OZJOez4BNSwL0Hwe18YjowW6IAZsIMZ63S7G1HVl6WqgPjmxqzE2jb0Iv12oUn1bxzgq.QK8eg1pvTsSotY0QLrxmfbekV42qd1bmzf4qnMpkvtEoNVC.LVxv_3btigfAEXn5ggrceDnAIwlW2VepdL3G0sEl9x2dzgOsiKeCvc7_lXsqZEF3EN08.4dEs.IcMetj9JT63Khd4ZKI-
X-Mailer: YahooMailClassic/9.1.10 YahooMailWebService/0.8.100.260964
Date: Mon, 25 Jan 2010 16:34:40 -0800 (PST)
From: john smith <whalajam@yahoo.com>
Subject: perf report for .ko files
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How can "perf report" be used to get info on (only) the specific manually loadable modules?
Driver entry points are reported but without full breakdown (on all the calls).
If "--symbols" option is used, most of the symbols are not found.
("--dsos" doesn't seem to help)

John


      
