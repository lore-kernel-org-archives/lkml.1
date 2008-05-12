Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbYELKXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbYELKXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759878AbYELKXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:23:05 -0400
Received: from twin.jikos.cz ([213.151.79.26]:35232 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759560AbYELKXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:23:03 -0400
Date: Mon, 12 May 2008 12:22:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Mikhail Kshevetskiy <kl@laska.dorms.spbu.ru>
cc: linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.25: early exception 0e
In-Reply-To: <20080510105712.74f17c01@laska>
Message-ID: <Pine.LNX.4.64.0805121221480.30585@twin.jikos.cz>
References: <20080510105712.74f17c01@laska>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2008, Mikhail Kshevetskiy wrote:

> I have the following boot problem:
[ ... ]
> PANIC: early exception 0e rip 10:ffffffff80224b4e error 0 cr2 ffffffffff5fb030

There should be a stack trace following this message, please post it (we 
need to know what function does 0xffffffff80224b4e correspond to, at 
least).

-- 
Jiri Kosina
SUSE Labs

