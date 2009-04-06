Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbZDFTgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbZDFTgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbZDFTft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:35:49 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:37832 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbZDFTfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:35:48 -0400
Message-ID: <49DA596A.5090104@oracle.com>
Date: Mon, 06 Apr 2009 12:35:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-04-05-21-45 uploaded
References: <200904060450.n364oaUj031923@imap1.linux-foundation.org>
In-Reply-To: <200904060450.n364oaUj031923@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.49DA5962.015D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-04-05-21-45 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 
> It contains the following patches against 2.6.29:


Duplicate functions merged here (2 functions duplicated),
so *all* (of my) builds fail with these errors:


mmotm-2009-0405-2145/scripts/kallsyms.c:550: error: redefinition of 'may_be_linker_script_provide_symbol'
mmotm-2009-0405-2145/scripts/kallsyms.c:505: error: previous definition of 'may_be_linker_script_provide_symbol' was here
mmotm-2009-0405-2145/scripts/kallsyms.c:584: error: redefinition of 'prefix_underscores_count'
mmotm-2009-0405-2145/scripts/kallsyms.c:539: error: previous definition of 'prefix_underscores_count' was here


-- 
~Randy
