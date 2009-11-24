Return-Path: <linux-kernel-owner+w=401wt.eu-S932871AbZKXNCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871AbZKXNCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932700AbZKXNCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:02:35 -0500
Received: from mx1.alphion.com ([75.147.97.34]:34862 "EHLO mx1.alphion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932667AbZKXNCe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:02:34 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Need Info about IDE driver
Date: Tue, 24 Nov 2009 08:02:35 -0500
Message-ID: <846629303ABF174A9EA5BB26D6965A594D5465@MX2.AlphionCorp.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Need Info about IDE driver
Thread-Index: AcptA45Ef2JhdUFWTuaQKdZdlFRn8AAASa+QAABSz2A=
From: "Sachin Rane" <SRane@alphion.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi,
 
I am new to  'IDE' Linux driver.
Before writing this mail I tried to get information from internet but
couldn't hit the website which can give developer point of view
information.
 
I am going through the code '
kernel-2.6.16.1-ts.amcc440gx.basic.1/drivers/ide/pci/siimage.c' and user
manual for 'Sil0680' to understand how the IDE driver works.

I have very basic questions:
1. What does mean the value '2' i.e. 'Custom' which has been set for
'hwif->mmio'
 
2. Where I can find details about 'TaskFile'?

  
Regards,
Sachin Rane
