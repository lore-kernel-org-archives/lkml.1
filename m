Return-Path: <linux-kernel-owner+w=401wt.eu-S1161059AbXAZQ6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161059AbXAZQ6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161057AbXAZQ6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:58:18 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59597 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030786AbXAZQ51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:57:27 -0500
Date: Fri, 26 Jan 2007 17:56:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, dhowells@redhat.com,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 3/4] coredump: add a sysctl parameter to disable the core dump omitting feature
Message-ID: <20070126165634.GA1269@elf.ucw.cz>
References: <45BA0A93.30004@hitachi.com> <45BA0CDD.5070604@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BA0CDD.5070604@hitachi.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-01-26 23:14:53, Kawai, Hidehiro wrote:
> This patch adds kernel.core_flags_enable sysctl parameter, which allows
> root user to disable the /proc/<pid>/core_flags feature globally.

What is it good for?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
