Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYL2JFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYL2JFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 04:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYL2JFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 04:05:09 -0500
Received: from web30101.mail.mud.yahoo.com ([209.191.69.33]:32317 "HELO
	web30101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753932AbYL2JFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 04:05:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=Te9NQUIiJPNdWRMtA2B42LbnUUHRjKsM58p3JRCYkwnciMT+NKVjSsINoJQCs+YfAgtXkT5sMOa0/yefGQoZEYaFQ4g6wPpexy5yFQBsEO+yL+y6PFkPze9+qRCNgVjU83qfhQdEqeAOy+JAjbECUnR50muHaRheFMPVMl2l23c=;
X-YMail-OSG: eDEtEB4VM1lMLy1mYeg1Is05qmZ7oOKbUUghrwR8eRnTrCMexEnMxljQL66ZFZv0A0agjigJYw20UM3l2tTNX2lZfAr2FWpT284pnjDLnL.JNGk5esEiZHMy8HRiInYz2HXls4HKu20ZufZTQkmrYQAScrOcZyY2fwHPp2eEYFS7J4jyN0A4GWfRim2d
X-Mailer: YahooMailWebService/0.7.260.1
Date: Mon, 29 Dec 2008 01:05:02 -0800 (PST)
From: Parav Pandit <paravpandit@yahoo.com>
Reply-To: paravpandit@yahoo.com
Subject: finding correct ib_device to call connect()
To: Linux kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <649524.70022.qm@web30101.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is this the right mailing list for Infiniband, RDMA-iWarp related Linux kernel issues?

Assuming yes,
1. Let's say there are two iWarp adapters, they both are in different subnet.
Their respective net_device is configured in different subnet.
(say one from Chelsio and other from Neteffect vendor)

How does connection manager module figures how that a connect() call should be diverted to which ib_device?

Regards,
Parav Pandit




      
