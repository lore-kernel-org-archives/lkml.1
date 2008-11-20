Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYKTQGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYKTQGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 11:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbYKTQGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 11:06:16 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:25274 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104AbYKTQGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:06:14 -0500
Message-ID: <49258AC4.7010800@oracle.com>
Date: Thu, 20 Nov 2008 08:05:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jes Sorensen <jes@sgi.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] docbook build fix, update include path
References: <49242F3A.9000007@sgi.com> <20081119080708.ac702f9d.randy.dunlap@oracle.com> <49252A79.1050702@sgi.com>
In-Reply-To: <49252A79.1050702@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49258AC9.001A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jes Sorensen wrote:
> Randy Dunlap wrote:
>> On Wed, 19 Nov 2008 16:22:34 +0100 Jes Sorensen wrote:
>>> Build fix for kerneldoc
>>
>> <attachment :( >
>>
>> Hi Jes,
>> Is your git tree up-to-date?  This should already be fixed.
> 
> Hi Randy,
> 
> I did a git pull right before running into the problem. Still haven't
> gotten the %$#$%# thing to build though, but this got it a little
> further.
> 
> If you can tell me how to make kerneldoc build on Fedora I would much
> appreciate it (maybe in a seperate thread/email).

BTW, I use "make htmldocs".  Both "make psdocs" and "make pdfdocs"
have toolchain failures (AFAIK) and I don't know what to do about them.

-- 
~Randy
