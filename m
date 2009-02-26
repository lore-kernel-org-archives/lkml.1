Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbZBZASm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbZBZASm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbZBZASc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:18:32 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:32846 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZBZASb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:18:31 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>
	<49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
	<49A5D76A.3010301@zytor.com> <yq11vtmhy0x.fsf@sermon.lab.mkp.net>
	<49A5DAE7.3060409@zytor.com> <yq1skm2giwa.fsf@sermon.lab.mkp.net>
	<49A5DDF7.9070301@zytor.com>
Date: Wed, 25 Feb 2009 19:17:08 -0500
In-Reply-To: <49A5DDF7.9070301@zytor.com> (H. Peter Anvin's message of "Wed\, 25 Feb 2009 16\:10\:31 -0800")
Message-ID: <yq1k57egigr.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49A5DF87.01CC:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:

hpa> That's ridiculously stupid.  All you need is an offset parameter,
hpa> which can be flipped at will.  Now, flipping it will obviously
hpa> scramble all data, but there is absolutely no reason why it
hpa> shouldn't be possible to instantaneously flip it back and forth.

I'm just quoting what I was told a few months ago.  I'm not
participating in IDEMA and for all I know that approach could have
changed again.

I'll ask one of my contacts to find out what the current status is...

-- 
Martin K. Petersen	Oracle Linux Engineering
