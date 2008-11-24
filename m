Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYKXXRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYKXXRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 18:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbYKXXRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 18:17:11 -0500
Received: from [198.99.130.12] ([198.99.130.12]:39724 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbYKXXRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 18:17:10 -0500
Date: Mon, 24 Nov 2008 18:16:07 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>, lkml <linux-kernel@vger.kernel.org>,
       kbuild <linux-kbuild@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 8/8] kbuild: move tags support to a shell script
Message-ID: <20081124231607.GA16583@c2.user-mode-linux.org>
References: <20081124205150.GA32497@uranus.ravnborg.org> <1227560095-32597-8-git-send-email-sam@ravnborg.org> <1227564434.16868.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227564434.16868.14.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 10:07:14PM +0000, Ian Campbell wrote:
> I'm not quite sure I understand the distinction between ARCH, SRCARCH
> and SUBARCH either but is it expected that for ARCH=um, SUBARCH will be
> i386/x86_64 or x86?

Yes, this is for UML to be able to tell what the underlying arch is.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
