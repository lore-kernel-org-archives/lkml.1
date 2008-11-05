Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbYKEQZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbYKEQZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYKEQZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:25:06 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:57842 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYKEQZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:25:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=M8edylmvzf2aiMTVAdQEYhd9/TmW/EoFJwu8ic/5o58u+0EOc60JKnL6vuz5J+HDti
         rrLc86mVLjCtlOdUlnOGgbP+MmWyZ+w43Zud+AWknK9yUH2HNM+N52t+yRmfUT3rk81V
         QwMddu54mniF9Ao6yeJXzmsOMdV0YpZQJ+GeA=
Message-ID: <804dabb00811050825td613b25lf400f4963e83e78c@mail.gmail.com>
Date: Thu, 6 Nov 2008 00:25:02 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: make htmldocs errors
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is on the latest linus tree (75fa67706cce5272bcfc51ed646f2da21f3bdb6e):

/mnt/hd0/download/linux-2.6-latest>make htmldocs
make[1]: *** No rule to make target `include/asm-x86/io_32.h', needed
by `Documentation/DocBook/deviceiobook.xml'.  Stop.
make: *** [htmldocs] Error 2



-- 
Regards,
Peter Teoh
