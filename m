Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbYDIAYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbYDIAYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 20:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYDIAYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 20:24:13 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:51186 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497AbYDIAYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 20:24:12 -0400
Subject: "x86: tsc prevent time going backwards" broke suspend
From: Alok Kataria <akataria@vmware.com>
To: bug-track@fisher-privat.net
Cc: bunk@kernel.org, tglx@linuxtronix.de, rjw@sisk.pl, pavel@suse.cz,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       Dan Hecht <dhecht@vmware.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: VMware, Inc.
Date: Tue, 08 Apr 2008 17:24:04 -0700
Message-Id: <1207700644.5864.74.camel@promb-2n-dhcp158.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


http://bugzilla.kernel.org/show_bug.cgi?id=10410

Do we know what kind of BUG did we hit with this tsc fix during resume ?
Do we have any logs which will give some insights on that BUG ?

Please let me know incase there is any information regarding that.

Thanks,
Alok


