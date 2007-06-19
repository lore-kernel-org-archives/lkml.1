Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbXFSTPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbXFSTPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933144AbXFSTPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:15:30 -0400
Received: from terminus.zytor.com ([192.83.249.54]:42974 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112AbXFSTP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:15:28 -0400
Message-ID: <46782B43.2060102@zytor.com>
Date: Tue, 19 Jun 2007 12:15:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
CC: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, alan <alan@clueserver.org>
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673182B.4090800@redhat.com> <46739E89.1080003@hawkeye.stone.uk.eu.org> <46781A5B.9090104@redhat.com> <467829C4.5020101@zytor.com> <46782AA5.2000108@hawkeye.stone.uk.eu.org>
In-Reply-To: <46782AA5.2000108@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Stone wrote:
> 
> But that would cause havoc with shells which use ; to seperate commands.
> Using ; would defiantly break userspace
> 

Not really.  It's just a bit awkward to use, but so's the whole concept.

	-hpa
