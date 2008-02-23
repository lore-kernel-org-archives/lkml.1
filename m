Return-Path: <linux-kernel-owner+w=401wt.eu-S933000AbYBWMDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbYBWMDv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762022AbYBWMDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:03:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761502AbYBWMDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:03:15 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <12037546111887-git-send-email-xiyou.wangcong@gmail.com>
References: <12037546111887-git-send-email-xiyou.wangcong@gmail.com> <12037544592096-git-send-email-xiyou.wangcong@gmail.com> <12037544671847-git-send-email-xiyou.wangcong@gmail.com> <1203754478165-git-send-email-xiyou.wangcong@gmail.com> <1203754488669-git-send-email-xiyou.wangcong@gmail.com> <12037544991876-git-send-email-xiyou.wangcong@gmail.com> <1203754509934-git-send-email-xiyou.wangcong@gmail.com> <1203754519825-git-send-email-xiyou.wangcong@gmail.com> <12037545311452-git-send-email-xiyou.wangcong@gmail.com> <12037545424136-git-send-email-xiyou.wangcong@gmail.com> <12037545522455-git-send-email-xiyou.wangcong@gmail.com> <12037545611159-git-send-email-xiyou.wangcong@gmail.com> <1203754571655-git-send-email-xiyou.wangcong@gmail.com> <1203754579637-git-send-email-xiyou.wangcong@gmail.com> <1203754594597-git-send-email-xiyou.wangcong@gmail.com> <12037546033003-git-send-email-xiyou.wangcong@gmail.com> 
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, yasutake.koichi@jp.panasonic.com
Subject: Re: [PATCH 15/16] mn10300: use get_personality()
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Sat, 23 Feb 2008 12:03:00 +0000
Message-ID: <591.1203768180@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong <xiyou.wangcong@gmail.com> wrote:

> Use get_personality() macro instead of explicit reference
> for mn10300 code.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-By: David Howells <dhowells@redhat.com>
