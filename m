Return-Path: <linux-kernel-owner+w=401wt.eu-S937564AbZAPWIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937564AbZAPWIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 17:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbZAPWIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 17:08:13 -0500
Received: from hpsmtp-eml16.KPNXCHANGE.COM ([213.75.38.116]:25327 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759293AbZAPWIM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 17:08:12 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [SOLVED] Linux 2.6.29-rc2 - build error in drivers/firmware/dmi_scan.c
Date: Fri, 16 Jan 2009 23:08:09 +0100
User-Agent: KMail/1.9.9
References: <alpine.LFD.2.00.0901161244310.4965@localhost.localdomain> <200901162259.12602.elendil@planet.nl>
In-Reply-To: <200901162259.12602.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901162308.09816.elendil@planet.nl>
X-OriginalArrivalTime: 16 Jan 2009 22:08:10.0506 (UTC) FILETIME=[EB17B6A0:01C97826]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009, you wrote:
> drivers/firmware/dmi_scan.c:421: error: conflicting types for ‘dmi_match’
> include/linux/dmi.h:51: error: previous declaration of ‘dmi_match’ was here
> drivers/firmware/dmi_scan.c: In function ‘dmi_first_match’:
> drivers/firmware/dmi_scan.c:488: warning: return discards qualifiers
> from pointer target type
> drivers/firmware/dmi_scan.c:483: warning: unused variable ‘i’
> drivers/firmware/dmi_scan.c: At top level:
> drivers/firmware/dmi_scan.c:630: error: conflicting types for ‘dmi_match’
> drivers/firmware/dmi_scan.c:422: error: previous definition of ‘dmi_match’ was here
> make[4]: *** [drivers/firmware/dmi_scan.o] 
> Error 1

Never mind. Was due to a local error.
Sorry for the noise.
