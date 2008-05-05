Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbYEECZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbYEECZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 22:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbYEECZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 22:25:01 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:25814 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbYEECZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 22:25:00 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Patches for piping to core pattern ?
Date: Sun, 4 May 2008 19:24:59 -0700
Message-ID: <FA6FB5FA4DA6BF4386D129273B2E3EC3034CA104@xmb-sjc-214.amer.cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Patches for piping to core pattern ?
Thread-Index: AciuVzdQMEZvXAw6RQuSms3QYq/0tQ==
From: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 May 2008 02:24:59.0881 (UTC) FILETIME=[37A1FD90:01C8AE57]
Authentication-Results: sj-dkim-1; header.From=rarakali@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am trying to port the "piping cores to an executable" to
our kernel (2.6.10 based). I took Andi Kleen's patch (3/3)
available at http://lwn.net/Articles/195310/ and some of
the supporting functions from 2.6.19. But it's not working
for me.

Andi's patch mentions "Using the infrastructure created in 
previous patches implement support to pipe core dumps into 
programs."

Can somebody point me to these previous patches ?

Thanks,
Ravi
