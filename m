Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbYJPIVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbYJPIVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 04:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYJPIVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 04:21:30 -0400
Received: from cpsmtpo-eml03.kpnxchange.com ([213.75.38.152]:49051 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942AbYJPIV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 04:21:29 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Is Debug Store supposed to default to Y?
Date: Thu, 16 Oct 2008 10:21:24 +0200
User-Agent: KMail/1.9.9
Cc: Markus Metzger <markus.t.metzger@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810161021.25572.elendil@planet.nl>
X-OriginalArrivalTime: 16 Oct 2008 08:21:26.0299 (UTC) FILETIME=[2EAD66B0:01C92F68]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both CONFIG_X86_DS and X86_PTRACE_BTS currently default to yes.
Is that intended?

The help text is a bit short on info to help users determine if they 
really need/want these options. What will I be missing if I don't enable 
them on a regular desktop system? What is their cost?

Cheers,
FJP
