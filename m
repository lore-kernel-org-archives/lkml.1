Return-Path: <linux-kernel-owner+w=401wt.eu-S1161599AbXDXGbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161599AbXDXGbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 02:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161602AbXDXGbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 02:31:49 -0400
Received: from dgate2.fujitsu-siemens.com ([217.115.66.36]:60149 "EHLO
	dgate2.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161599AbXDXGbs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 02:31:48 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=xzyUWG5X5bpQcgm8kFkbF2ug1trHX5hejxxENCWCiwESzPD+FYrceaTtp1mhyPqRkqugNyM26Mmrr53zGQ+CxeRYIcNKjqGSJVeOeq7oEYeHb/B0n/+sufDdPgAutckG;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.14,445,1170630000"; 
   d="scan'208";a="66295048"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: NonExecutable Bit in 32Bit
Date: Tue, 24 Apr 2007 08:31:11 +0200
Message-ID: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF052CFB78@ABGEX01E.abg.fsc.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: NonExecutable Bit in 32Bit
Thread-Index: AceFsoNA5+/3Qe7XRySx2xciN9/cigAh5dAA
From: "Cestonaro, Thilo \(external\)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 24 Apr 2007 06:31:46.0849 (UTC) FILETIME=[3B8A4110:01C7863A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

is it right, that the NX Bit is not used under i386-Arch but under x86_64-Arch?
When yes, is there a special argument for it not to be used?

Ciao Thilo
