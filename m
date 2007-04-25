Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbXDYOXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbXDYOXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 10:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932282AbXDYOXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 10:23:04 -0400
Received: from ihemail2.lucent.com ([135.245.0.35]:57307 "EHLO
	ihemail2.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbXDYOXD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 10:23:03 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6249.0
Subject: about linux console and printk
Date: Wed, 25 Apr 2007 22:22:22 +0800
Message-ID: <2AC135F730C4A045BAE4F1C1CB83FD4B03EF6B90@exch03.qd.lucent.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Getting the new RxRPC patches upstream 
Thread-Index: AceHQOkuqfVptgVwQbqvHdiPVPMVWgABCIEg
From: "Shan, Guo Wen (Gavin)" <gshan@alcatel-lucent.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
X-OriginalArrivalTime: 25 Apr 2007 14:22:23.0482 (UTC) FILETIME=[244C45A0:01C78745]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

The linux could support several console driver at same time? If so, what I need to do is call register_console() for several times?

Thanks,
Gavin
