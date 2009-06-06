Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbZFFAqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbZFFAqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 20:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZFFAqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 20:46:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62087 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbZFFAqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 20:46:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 18/39] kbuild/headers_check: refine extern check
Date: Sat, 6 Jun 2009 00:46:07 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: "linux-kbuild" <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Amerigo Wang <amwang@redhat.com>
References: <20090605233720.GA13588@uranus.ravnborg.org> <1244245377-17441-18-git-send-email-sam@ravnborg.org>
In-Reply-To: <1244245377-17441-18-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906060046.07421.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/mdZdUI6zbnnAXGn9Pp9EseNA2XrbbXc/Ze2t
 Eu8Ap2jD7FWOGtBkWD7LGd9YEZQ2i7yJbek0QsiGM0Y1pg+P2P
 nmu44Fmii5a5PO4VgtjTQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 June 2009 11:42:36 pm Sam Ravnborg wrote:
> From: Amerigo Wang <amwang@redhat.com>
> 
> 'extern' checking information is not clear, refine it.
> Plus, fix a comment.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

I still think this is pointless and should just be removed
(or replaced with a patch to kill the apostrophe in there).

	Arnd <><
