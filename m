Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbXFSUiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbXFSUiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbXFSUip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:38:45 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:35633
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752680AbXFSUio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:38:44 -0400
Message-ID: <46783EAE.6050804@hawkeye.stone.uk.eu.org>
Date: Tue, 19 Jun 2007 21:38:06 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       "H. Peter Anvin" <hpa@zytor.com>, alan <alan@clueserver.org>,
       Chris Snook <csnook@redhat.com>
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org>	<4673182B.4090800@redhat.com>	<46739E89.1080003@hawkeye.stone.uk.eu.org>	<46781A5B.9090104@redhat.com>	<4678292B.6000804@hawkeye.stone.uk.eu.org>	<4678369C.7070908@redhat.com>	<467837AB.4030607@hawkeye.stone.uk.eu.org> <18040.15842.698982.608861@stoffel.org>
In-Reply-To: <18040.15842.698982.608861@stoffel.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Stoffel wrote:
>>>>>> "Jack" == Jack Stone <jack@hawkeye.stone.uk.eu.org> writes:
> 
> Jack> The whole idea of the file system is that it wouldn't return the
> Jack> file in the file listing. The user would have to know that the
> Jack> file system was versioning to access the older versions as they
> Jack> would explicitly have to request them.
> 
> So tell me what happens when I do:
> 
> 	touch foo:121212121212
> 
> 

<joke>
This fs crashes and burns because the interface still isn't correct.
</joke>

Honestly, I don't know and this will be the problem of any interfaces
that follow this format.

Jack
