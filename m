Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbYFIWdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbYFIWdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYFIWdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:33:36 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:26395 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYFIWdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=F8RYMy2273vlIvw/iFmRn7lMM0rpuEwYx64BHaWXJa4n46uPgANdFoEBSEL5xnwo9j
         m2eaMSLhjmLS2P/USQqxGnw4V+D1JF5CJ/iAMZCz6UchuUWKYiUN6UIpNTpZWLk6eiSm
         fUY5SjK6cTpm1rI5ozDoibdjiNYjuGztJ+92M=
To: linux-kernel@vger.kernel.org
Subject: [patch 00/21] perfmon2 minimal:  introduction
From: eranian@googlemail.com
Date: Mon, 09 Jun 2008 15:33:32 -0700 (PDT)
Message-ID: <484dafbc.09a1660a.2a60.274a@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following patches implement a minimal perfmon2 subsystem which provides
access to the hardware performance counters of modern processors.

This series supports ONLY per-thread counting of PMU events (no sampling) for 
AMD64 and Intel processors supporting architectural perfmon (version 1 and 2)
in both 32 and 64 bit modes.

Please review.

Signed-off-by: Stephane Eranian <eranian@gmail.com>

-- 

