Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbYDXKOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbYDXKOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 06:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYDXKOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 06:14:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:5600 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYDXKOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 06:14:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Y5X7LFwRDXjb3Dlyao16pcRxMxDtu8htodUvZ0ZoAAqOT/SfJDh8hpdXCtfdOG+80CW8g38zcsr8tXMuN9nIIKZFvZooDmsatD3SEWYne+qe74gq/oymTe2CVbTiNnvH58txxYvV6dSwewLF1TdJIZShXbKmMie76z03+QoNjq0=
Message-ID: <18b669d80804240314t7b2f6e4cpc9a9f2690c6d21b4@mail.gmail.com>
Date: Thu, 24 Apr 2008 19:14:38 +0900
From: "Shigeo N" <shigeonx@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: XTP for 2.6.25
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I implemented Xpress Transport Protocol 4.0 for Linux kernel 2.6.25.
Does anyone test it and give me feedback to enhance together ?

I tested in the network where UDP throughput is 29Mbps, then TCP
throughput was 13Mbps, but XTP's reached to 25Mbps.

The source is here.
<http://downloads.sourceforge.net/linux-xtp/linux-xtp.0.3.1.tar.gz?use_mirror=osdn>

XTP specification is here.
<http://www.packeteer.com/resources/prod-sol/XTP.pdf>

Multicast function is not implemented yet.

Thanks,
Shigeo N
