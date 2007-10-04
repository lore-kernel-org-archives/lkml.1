Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbXJDUAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbXJDUAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 16:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbXJDUAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 16:00:20 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:65002 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbXJDUAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 16:00:19 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Decreasing stime running confuses top
Date: Thu, 4 Oct 2007 22:00:03 +0200
User-Agent: KMail/1.9.7
Cc: Luca Tettamanti <kronos.it@gmail.com>, Frans Pop <elendil@planet.nl>,
       Willy Tarreau <w@1wt.eu>, LKML <linux-kernel@vger.kernel.org>,
       Ilpo =?iso-8859-1?q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "Alexander E. Patrakov" <patrakov@ums.usu.ru>
References: <200710031433.34504.elendil@planet.nl> <20071004191921.GA24011@dreamland.darkstar.lan> <47053FC7.2070308@redhat.com>
In-Reply-To: <47053FC7.2070308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710042200.03489.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 4. Oktober 2007 schrieb Chuck Ebbert:
> Is CONFIG_VIRT_CPU_ACCOUNTING set?

This is s390 and powerpc only, so the answer is probably no ;-)
