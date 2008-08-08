Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbYHHSzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbYHHSzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbYHHSy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:54:56 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37062 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbYHHSyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:54:55 -0400
Subject: [PATCH 0/4] integrity
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com
Content-Type: text/plain
Date: Fri, 08 Aug 2008 14:54:51 -0400
Message-Id: <1218221691.4444.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-- 
I've brought the LIM/IMA patchset up to date, resolving the latest
merge issues resulting from the removal of the nameidata parameter to
inode_permission(), and built the patches on top of James's
security-testing 'devel' tree as per his request.

This patchset contains 4 patches:
        Patch 1/4 integrity: TPM internal kernel interface
        Patch 2/4 integrity: special fs magic
        Patch 3/4 integrity: Linux Integrity Module(LIM)
        Patch 4/4 integrity: IMA as an integrity service provider


