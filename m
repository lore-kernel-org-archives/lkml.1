Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbZAIMsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbZAIMsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 07:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZAIMsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 07:48:42 -0500
Received: from p02c12o141.mxlogic.net ([208.65.145.74]:49639 "EHLO
	p02c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbZAIMsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 07:48:41 -0500
Message-ID: <496747A4.7090909@steeleye.com>
Date: Fri, 09 Jan 2009 07:48:36 -0500
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, akpm@osdl.org
Subject: Re: nbd: trivial cleanups
References: <20090109100622.GA3585@elf.ucw.cz>
In-Reply-To: <20090109100622.GA3585@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jan 2009 12:48:37.0091 (UTC) FILETIME=[96E2E330:01C97258]
X-Spam: [F=0.2000000000; S=0.200(2008120801)]
X-MAIL-FROM: <paul.clements@steeleye.com>
X-SOURCE-IP: [71.30.118.242]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Trivial cleanups for nbd: only the return -EIO one really changes
> code, and I've verified all the callers (plus 0 == success, 1 == error
> convention is really ugly).
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>

Looks good
