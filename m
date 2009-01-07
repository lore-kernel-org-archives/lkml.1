Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbZAGRrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbZAGRrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZAGRr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:47:28 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:50602 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbZAGRr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:47:28 -0500
Message-ID: <4964EA9C.1000204@oracle.com>
Date: Wed, 07 Jan 2009 09:47:08 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter W Morreale <pmorreale@novell.com>
Subject: Re: mmotm 2009-01-07-00-23 uploaded
References: <200901070828.n078SRKJ024599@imap1.linux-foundation.org> <4964BEB0.7040400@gmail.com>
In-Reply-To: <4964BEB0.7040400@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0205.4964EAA2.0127:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 01/07/2009 09:28 AM, akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2009-01-07-00-23 has been uploaded to
> 
> Hi,
> 
> there is wrong parenthesis pairing added in:
> patches/mm-add-proc-controls-for-pdflush-threads-fix.patch
> which causes a build error.

(lots of those)

adding cc: to Peter M.


-- 
~Randy
