Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbYAOGug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbYAOGug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 01:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYAOGu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 01:50:28 -0500
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:65148 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbYAOGu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:50:27 -0500
X-Greylist: delayed 1386 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2008 01:50:27 EST
Message-ID: <478C5244.3010906@freemail.hu>
Date: Tue, 15 Jan 2008 07:27:16 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: EC: slow ACPI sensors starting at 2.6.20-rc2, unless ec_intr=0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tested linux-2.6.24-rc7 on my Clevo D410J, but it seems
that this version still have some smaller problems with this
hardware.

See http://bugzilla.kernel.org/show_bug.cgi?id=8459 for details.

Regards,

	Márton Németh
