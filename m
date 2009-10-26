Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbZJZHjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbZJZHjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbZJZHjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:39:03 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:57404 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754782AbZJZHjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:39:02 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Zhang Rui <rui.zhang@intel.com>,
       Sujith Thomas <sujith.thomas@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Frans Pop <elendil@planet.nl>
Subject: [PATCH 0/6] [resend] thermal: improvements re. forced passive cooling
Date: Mon, 26 Oct 2009 08:38:58 +0100
Message-Id: <1256542744-26569-1-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 26 Oct 2009 07:39:05.0733 (UTC) FILETIME=[654A0B50:01CA560F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please consider this patch set for 2.6.32. It was previously submitted
for 2.6.31, but AFAICT it has not yet been picked up.

All patches have been acked by either Rui or Matthew, with the
exception of 1/6 and 4/6, but the entire series has been implicitly
acked by Rui in http://bugzilla.kernel.org/show_bug.cgi?id=13918#c26.

The patch set closes http://bugzilla.kernel.org/show_bug.cgi?id=13918.

Andrew, could you take the set just in case?

Cheers,
FJP
