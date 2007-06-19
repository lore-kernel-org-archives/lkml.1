Return-Path: <linux-kernel-owner+w=401wt.eu-S933880AbXFSTYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880AbXFSTYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760044AbXFSTX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:23:59 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:45257
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759564AbXFSTX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:23:58 -0400
Message-ID: <46782D13.6000209@hawkeye.stone.uk.eu.org>
Date: Tue, 19 Jun 2007 20:22:59 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, alan <alan@clueserver.org>
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673182B.4090800@redhat.com> <46739E89.1080003@hawkeye.stone.uk.eu.org> <46781A5B.9090104@redhat.com> <467829C4.5020101@zytor.com> <46782AA5.2000108@hawkeye.stone.uk.eu.org> <46782B43.2060102@zytor.com>
In-Reply-To: <46782B43.2060102@zytor.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jack Stone wrote:
>> But that would cause havoc with shells which use ; to seperate commands.
>> Using ; would defiantly break userspace
>>
> 
> Not really.  It's just a bit awkward to use, but so's the whole concept.

I think we can all agree on that after this thread but I still don't
want people to have the wrong idea about the design.

Jack

