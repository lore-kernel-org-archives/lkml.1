Return-Path: <linux-kernel-owner+w=401wt.eu-S1423216AbXDYGUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423216AbXDYGUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423222AbXDYGUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:20:20 -0400
Received: from dgate1.fujitsu-siemens.com ([217.115.66.35]:3249 "EHLO
	dgate1.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423216AbXDYGUS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:20:18 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=j2lDz82CGKKwOwMJTZv/DnJtfIFni31WiORGVPn2/0FCk3T/xh0Oca93gvoH+PQSgVy7F0M2cuysXfp2k6v7R514hZ52CCQ6OogymYOij0CxXB24r8mlA+62qr5iEAWo;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.14,449,1170630000"; 
   d="scan'208";a="72576079"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: NonExecutable Bit in 32Bit
Date: Wed, 25 Apr 2007 08:19:39 +0200
Message-ID: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF0530256E@ABGEX01E.abg.fsc.net>
In-Reply-To: <4ac8254d0704240046s23b2d349m2e0f0caa7eb95a91@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: NonExecutable Bit in 32Bit
Thread-Index: AceGRJsNAkIdjxq3R/m7aDKbChm4nAAvM0vg
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF052CFB78@ABGEX01E.abg.fsc.net> <Pine.LNX.4.64.0704240640470.25153@server.thyself> <4ac8254d0704240046s23b2d349m2e0f0caa7eb95a91@mail.gmail.com>
From: "Cestonaro, Thilo \(external\)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
To: "Tuncer Ayaz" <tuncer.ayaz@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 25 Apr 2007 06:20:03.0310 (UTC) FILETIME=[C29C78E0:01C78701]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

> CONFIG_HIGHMEM64G=y
> CONFIG_HIGHMEM=y
> CONFIG_X86_PAE=y

Ok in highmem it's active, whats about lowmem?
x86-64 is NX active for lowmem too AFAIK.


Ciao Thilo
