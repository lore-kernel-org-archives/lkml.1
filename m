Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbYDFSxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbYDFSxo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 14:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYDFSxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 14:53:37 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1769 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbYDFSxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 14:53:36 -0400
Subject: Re: [patch] checkpatch: relax spacing and line length
From: Joe Perches <joe@perches.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, apw@shadowen.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <47F8B98A.1020704@panasas.com>
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr>
	 <20080405221822.376f0018.akpm@linux-foundation.org>
	 <47F8B98A.1020704@panasas.com>
Content-Type: text/plain
Date: Sun, 06 Apr 2008 11:52:51 -0700
Message-Id: <1207507971.1803.40.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-04-06 at 14:52 +0300, Benny Halevy wrote:
> The idea is [] to allow for a bit more flexibility to
>  accommodate for a more robust indentation style.

Isn't this an editor/tools issue more than a checkpatch one?

I think you should first try to get the most frequently used
code editors and pretty printers (vim/emacs/eclipse/indent, etc)
to support the tabs to level, spaces to align style.

g'luck with that.

