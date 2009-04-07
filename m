Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZDGLXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZDGLXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 07:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZDGLXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 07:23:35 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43519 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbZDGLXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 07:23:34 -0400
Subject: Next April 7 : x86 allmodconfig failure [kernel/module.c]
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       rusty <rusty@rustcorp.com.au>, rusty <rusty@au1.ibm.com>
In-Reply-To: <1239103297.5300.24.camel@subratamodak.linux.ibm.com>
References: <1239103297.5300.24.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Organization: IBM
Date: Tue, 07 Apr 2009 16:53:31 +0530
Message-Id: <1239103411.5300.26.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry,

This occurred on April 7th Tree.

On Tue, 2009-04-07 at 16:51 +0530, Subrata Modak wrote:
> Hi,
> 
> Following build failure occurs with April 7 next tree on x86, kernel
> configuration enabled as randconfig.
> 
> kernel/module.c: In function ‘sys_init_module’:
> kernel/module.c:2401: error: ‘modules_disabled’ undeclared (first use in
> this function)
> kernel/module.c:2401: error: (Each undeclared identifier is reported
> only once
> kernel/module.c:2401: error: for each function it appears in.)
> make[1]: *** [kernel/module.o] Error 1
> make: *** [kernel] Error 2
> 
> Regards--
> Subrata
> 

Regards--
Subrata


