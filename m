Return-Path: <linux-kernel-owner+w=401wt.eu-S934991AbXLNA1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934991AbXLNA1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764435AbXLNA1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:27:39 -0500
Received: from nofear-snat.bivio.net ([216.142.75.231]:31926 "EHLO
	corpexc01.corp.networkrobots.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763787AbXLNA1i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:27:38 -0500
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2007 19:27:38 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: printf internals
Date: Thu, 13 Dec 2007 16:07:41 -0800
Message-ID: <D83235F0F3C86D4D889D8B9A0DA8C6D7011A8217@corpexc01.corp.networkrobots.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: printf internals
Thread-Index: Acg95VfP5UnACjvFRfybz++UCeatKg==
From: "Siva Prasad" <sprasad@bivio.net>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am looking at how exactly does the printf in user programs succeeds in
displaying characters to the serial console.

printf uses /dev/console to write the data. Once written to
/dev/console, what happens to the string written?

Is there any way, I can get access to those prints/string inside the
kernel?

Thanks
Siva

