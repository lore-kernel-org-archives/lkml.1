Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYJZApq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYJZApq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 20:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYJZApi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 20:45:38 -0400
Received: from twin.jikos.cz ([213.151.79.26]:60781 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbYJZApi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 20:45:38 -0400
Date: Sun, 26 Oct 2008 02:45:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jiri Slaby <jirislaby@gmail.com>
cc: Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.28-rc1 regression] appletouch
In-Reply-To: <49038C5C.7000708@gmail.com>
Message-ID: <Pine.LNX.4.64.0810260244450.22126@twin.jikos.cz>
References: <1224966797.5303.3.camel@localhost> <49038C5C.7000708@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008, Jiri Slaby wrote:

> > I've noticed that the mouse does no longer work in X using 2.6.28-rc1 
> > nor does the fn-key emulation work on my macbookpro 1,1.
> > It perfectly works with 2.6.27.3...
> Please follow
> http://bugzilla.kernel.org/show_bug.cgi?id=11825

Yup. The patch fixing this issue is in the bunch for which the pull 
request has already been sent to Linus, but it didn't happen yet.

-- 
Jiri Kosina
SUSE Labs

