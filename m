Return-Path: <linux-kernel-owner+w=401wt.eu-S932810AbXFSTJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbXFSTJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932734AbXFSTJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:09:08 -0400
Received: from terminus.zytor.com ([192.83.249.54]:59030 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763192AbXFSTJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:09:07 -0400
Message-ID: <467829C4.5020101@zytor.com>
Date: Tue, 19 Jun 2007 12:08:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, alan <alan@clueserver.org>
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673182B.4090800@redhat.com> <46739E89.1080003@hawkeye.stone.uk.eu.org> <46781A5B.9090104@redhat.com>
In-Reply-To: <46781A5B.9090104@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> I pointed out NetApp's .snapshot directories because that's a method
> that uses legal path character, but doesn't break anything.  With this
> method, userspace tools will have to be taught that : is suddenly a
> special character.

Not to mention that the character historically used for this purpose is
; (semicolon.)

	-hpa
