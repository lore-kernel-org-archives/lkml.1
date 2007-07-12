Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbXGLUbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbXGLUbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758702AbXGLUbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:31:12 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:32928 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758393AbXGLUbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:31:10 -0400
Message-ID: <46968F88.7070300@acm.org>
Date: Thu, 12 Jul 2007 14:31:04 -0600
From: Zan Lynx <zlynx@acm.org>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Edward Shishkin <edward@namesys.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       "Vladimir V. Saveliev" <vs@namesys.com>
Subject: Re: 2.6.22-rc6-mm1 reiser4_tree_by_page NULL pointer
References: <1184090582.6933.20.camel@localhost> <469523FA.7010308@namesys.com>
In-Reply-To: <469523FA.7010308@namesys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Edward Shishkin wrote:
> 
> I have found the bug, which kills data
> when booting after crash, power loss, etc.
> The patch is attached.
> Please, ping me, if it doesn't help..

It appears to be holding up well so far.  About 5 hours of Gentoo 
updating and compiling.

