Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZAEWKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZAEWKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbZAEWJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:09:53 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:53642 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbZAEWJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:09:52 -0500
Message-ID: <49628515.7010609@oracle.com>
Date: Mon, 05 Jan 2009 14:09:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: dedekind@infradead.org, akpm <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-01-05-12-50 uploaded (ubifs)
References: <200901052050.n05Kox9j012519@imap1.linux-foundation.org>
In-Reply-To: <200901052050.n05Kox9j012519@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4962851F.0185:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-01-05-12-50 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git


mmotm-2009-0105-1250/fs/ubifs/super.c:435: error: 'WB_SYNC_HOLD' undeclared (first use in this function)


~Randy
