Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbZL3Rj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbZL3Rj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 12:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZL3Rj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 12:39:28 -0500
Received: from exprod6og110.obsmtp.com ([64.18.1.25]:33582 "HELO
	exprod6og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752525AbZL3Rj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 12:39:27 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] drivers/s390/net/qeth_l2_main.c: use %pM to shown MAC address
Date: Wed, 30 Dec 2009 12:39:25 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F62D@mi8nycmail19.Mi8.com>
In-Reply-To: <20091230.091643.246513654.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/s390/net/qeth_l2_main.c: use %pM to shown MAC address
Thread-Index: AcqJc9s/slIjou+8QfKSHPWHUUpsDQAAxKYg
References: <BD79186B4FD85F4B8E60E381CAEE19090200F4CF@mi8nycmail19.Mi8.com> <20091230.091643.246513654.davem@davemloft.net>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "David Miller" <davem@davemloft.net>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
       <linux-s390@vger.kernel.org>, <blaschka@linux.vnet.ibm.com>
X-OriginalArrivalTime: 30 Dec 2009 17:39:25.0477 (UTC) FILETIME=[07948D50:01CA8977]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 30, 2009 10:17 AM, wrote:
> From: "H Hartley Sweeten" <hartleys@visionengravers.com>
> Date: Mon, 28 Dec 2009 18:39:26 -0500
> 
>> Use the %pM kernel extension to display the MAC address.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>
> Applied.

Thanks for this one and the others.

Hartley
