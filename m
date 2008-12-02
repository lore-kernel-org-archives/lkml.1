Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYLBSOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYLBSOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 13:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbYLBSNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 13:13:52 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:44906 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYLBSNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 13:13:52 -0500
Message-ID: <49357AD0.7090005@oracle.com>
Date: Tue, 02 Dec 2008 10:13:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: linux-next: Tree for December 2 (staging)
References: <20081202173101.e2b72437.sfr@canb.auug.org.au>
In-Reply-To: <20081202173101.e2b72437.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49357AD3.010E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20081201:
> 
> Today's tree fails the powerpc allyesconfig build.

Greg,
FYI, the staging drivers still have lots of errors (as reported
over 1 week ago; yes, I know, holiday time), but I've stopped reporting
on them until I see some reason to think that fixes have been made.

-- 
~Randy
