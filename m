Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYKMRza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYKMRza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYKMRzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:55:17 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:56850 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYKMRzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:55:16 -0500
Date: Thu, 13 Nov 2008 09:55:01 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 13 (auditsc)
Message-Id: <20081113095501.7d91cd91.randy.dunlap@oracle.com>
In-Reply-To: <20081113183316.3601c13d.sfr@canb.auug.org.au>
References: <20081113183316.3601c13d.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.491C69F8.0104:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 18:33:16 +1100 Stephen Rothwell wrote:


auditsc build fails when
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_NETWORK is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set

error is:
auditsc.c:(.text+0x2afaf): undefined reference to `get_vfs_caps_from_disk'

---
~Randy-r5905
