Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZHYJSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZHYJSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbZHYJSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:18:41 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:44030 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbZHYJSk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:18:40 -0400
X-Greylist: delayed 2740 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Aug 2009 05:18:40 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: TCP keepalive timer problem
Date: Tue, 25 Aug 2009 04:32:45 -0400
Message-ID: <0939B589FC103041945B9F13274963E303B1A9D4@CORPUSMX90A.corp.emc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: TCP keepalive timer problem
Thread-Index: AcolXp6RDnJyI2A+QvWycC13GqrC/g==
From: <Li_Xin2@emc.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 25 Aug 2009 08:32:46.0481 (UTC) FILETIME=[9F64B010:01CA255E]
X-EMM-EM: Active
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I found one problem in Linux TCP keepalive timer processing, after
searching on google, I found Daniel Stempel reported the same problem in
2007 (http://lkml.indiana.edu/hypermail/linux/kernel/0702.2/1136.html),
but got no answer. So I have to reraise it.

Can anyone help answer this two-years long question?

Regards,
Xin Li
EMC Shanghai R&D Centre
Email: Li_Xin2@emc.com
Tel: 86 21 6095 1100 x 2257
