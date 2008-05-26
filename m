Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYEZJWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYEZJWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 05:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbYEZJWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 05:22:46 -0400
Received: from aun.it.uu.se ([130.238.12.36]:39584 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbYEZJWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 05:22:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <18490.33106.357734.800133@harpo.it.uu.se>
Date: Mon, 26 May 2008 11:22:26 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: =?utf-8?q?Kristian=20H=C3=B8gsberg?= <krh@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] Only print "Decompressing Linux" etc when 'debug' is passed.
In-Reply-To: <1211687267-12962-1-git-send-email-krh@redhat.com>
References: <1211687267-12962-1-git-send-email-krh@redhat.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=?utf-8?q?Kristian=20H=C3=B8gsberg?= writes:
 > Signed-off-by: Kristian Høgsberg <krh@redhat.com>
 > ---
 > 
 > Updated to use the standard 'debug' parameter instead of 'noisy'.
 > 
 >  arch/x86/boot/compressed/misc.c |   30 +++++++++++++++++++++++++++---
 >  1 files changed, 27 insertions(+), 3 deletions(-)

NAK

You still haven't explained why suppressing these
messages is necessary.
