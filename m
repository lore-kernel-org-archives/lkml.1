Return-Path: <linux-kernel-owner+w=401wt.eu-S1761266AbYGCM7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761266AbYGCM7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYGCM7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:59:12 -0400
Received: from mailer2.option.com ([81.246.70.163]:28546 "EHLO
	mailer2.option.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbYGCM7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:59:11 -0400
X-Greylist: delayed 3605 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2008 08:59:10 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8AAChUbEgKAAAZ/2dsb2JhbAAIsgk
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: tcp/ip connect on demand
Date: Thu, 3 Jul 2008 13:29:03 +0200
Message-ID: <F67862BE33DC784289A6B34E92908FCF393FFE@SRV-SATURNUS.OPTION.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: tcp/ip connect on demand
Thread-Index: Acjc//9kejefbADtTy6ghWMGQ9Adrg==
From: "Jens-Michael Hoffmann" <J.Hoffmann@option.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi,

what is the right way to implement a "connect on demand" feature?
Example: user types url in firefox and presses return. Then
the system should set up network devices and proceed as usual.

Is there a hook in the kernel we can use?

Best regards

Jens-Michael Hoffmann

ps: please cc me in replies since I'am not subscribed with this email.
