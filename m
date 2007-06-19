Return-Path: <linux-kernel-owner+w=401wt.eu-S934034AbXFSU22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034AbXFSU22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764078AbXFSU2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:28:19 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:52973
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759611AbXFSU2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:28:18 -0400
Message-ID: <46783C44.1040200@hawkeye.stone.uk.eu.org>
Date: Tue, 19 Jun 2007 21:27:48 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       "H. Peter Anvin" <hpa@zytor.com>, alan <alan@clueserver.org>
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673182B.4090800@redhat.com> <46739E89.1080003@hawkeye.stone.uk.eu.org> <46781A5B.9090104@redhat.com> <4678292B.6000804@hawkeye.stone.uk.eu.org> <4678369C.7070908@redhat.com> <467837AB.4030607@hawkeye.stone.uk.eu.org> <4678395B.4010805@redhat.com>
In-Reply-To: <4678395B.4010805@redhat.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
 > Okay, so now you have to modify ls, cp, tar, and thousands of other
> applications to be aware of the versioning, otherwise you can't use it.
> 
> Please don't get hung up on the interface.  This is a really cool
> feature that will require some serious engineering work to make it work
> right.  There's no need to reinvent hidden files as well, since we
> already have a decades-old standard for that.

I realise that but the way this is designed has quickly become a pain in
the past. I think that it would be easier to implement somthing like
what was suggested in this email:

http://www.ussg.iu.edu/hypermail/linux/kernel/0706.2/1156.html

I'm thinking of writing a simple proof of concept version and then
seeing what people think from there.

Jack
