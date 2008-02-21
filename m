Return-Path: <linux-kernel-owner+w=401wt.eu-S1764757AbYBULw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764757AbYBULw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759350AbYBULwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:52:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759322AbYBULwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:52:33 -0500
To: linux-kernel@vger.kernel.org
Cc: virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@pol.net,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       akpm@linux-foundation.org, jayakumar.lkml@gmail.com
Subject: Re: [PATCH 0/2] xen pvfb: Para-virtual framebuffer, keyboard and pointer
References: <871w76ejdg.fsf@pike.pond.sub.org>
From: Markus Armbruster <armbru@redhat.com>
Date: Thu, 21 Feb 2008 12:51:21 +0100
In-Reply-To: <871w76ejdg.fsf@pike.pond.sub.org> (Markus Armbruster's message of "Thu\, 21 Feb 2008 10\:42\:03 +0100")
Message-ID: <87hcg2cyti.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to mention: This patch depends on

    Subject: [PATCH] xen: Make xen-blkfront write its protocol ABI to xenstore
    From: Markus Armbruster <>
    Date: Thu, 06 Dec 2007 14:45:53 +0100

http://lkml.org/lkml/2007/12/6/132

Sorry!
