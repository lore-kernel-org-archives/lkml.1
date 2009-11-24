Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbZKXJWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbZKXJWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932431AbZKXJWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:22:03 -0500
Received: from gw.wifiinternet.cz ([89.31.42.6]:32819 "EHLO monstr.eu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932425AbZKXJWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:22:02 -0500
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org, grant.likely@secretlab.ca,
       john.williams@petalogix.com, stable@kernel.org, chrisw@sous-sol.org,
       greg@kroah.com
Subject: 8250 extend OF compatible list ns16550a
Date: Tue, 24 Nov 2009 10:21:41 +0100
Message-Id: <1259054502-28284-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need to extend OF compatible list for ns16550a.
I added this patch to microblaze next branch that's why
you can find it in next tree tomorrow.

Please add it to serial tree.

Could you please add this patch to stable tree too?
We would like to start to use stable tree. 

Thanks,
Michal



