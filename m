Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbYDPAet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbYDPAet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 20:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759151AbYDPAee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 20:34:34 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:45787 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbYDPAed convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 20:34:33 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Need patch for piping support in core_pattern
Date: Tue, 15 Apr 2008 17:34:31 -0700
Message-ID: <FA6FB5FA4DA6BF4386D129273B2E3EC3034CA06D@xmb-sjc-214.amer.cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Need patch for piping support in core_pattern
Thread-Index: AcifWaH0yp9PktDEQG6rrXXRMHfufw==
From: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Cc: <ak@suse.de>
X-OriginalArrivalTime: 16 Apr 2008 00:34:32.0519 (UTC) FILETIME=[A3918D70:01C89F59]
Authentication-Results: sj-dkim-3; header.From=rarakali@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I need the patch for pipe support in core_pattern that Andi Kleen
submitted earlier. This is required for 2.6.10 kernel. How do
I generate the latest patch for this ? I have Andi's patch that
was originally submitted (http://lwn.net/Articles/195310/).

Thanks,
Ravi
