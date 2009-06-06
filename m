Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbZFFPZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbZFFPZa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 11:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZFFPZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 11:25:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:50006 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbZFFPZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 11:25:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 18/39] kbuild/headers_check: refine extern check
Date: Sat, 6 Jun 2009 15:25:12 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: "linux-kbuild" <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Amerigo Wang <amwang@redhat.com>
References: <20090605233720.GA13588@uranus.ravnborg.org> <200906060046.07421.arnd@arndb.de> <20090606083844.GA14555@uranus.ravnborg.org>
In-Reply-To: <20090606083844.GA14555@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906061525.12876.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+sxvLj5ifoCfo6Qg0hiC/A75cpSIBG3phQPCU
 STChXr4+eJh8XUs6oi//tkdTBSMtoOIgiQ05jXwhXaE3CraHHF
 DPdZmjknAQ7ml1l4F/KVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 June 2009 08:38:44 am Sam Ravnborg wrote:

> Subject: kbuild/headers_check: refine extern check
> 
> 'extern' checking information is not clear, refine it.
> Plus, fix a comment.

Thanks!
 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> [sam: redid the extern error message]
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
