Return-Path: <linux-kernel-owner+w=401wt.eu-S1759630AbXHEMod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630AbXHEMod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 08:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756425AbXHEMoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 08:44:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:37954 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219AbXHEMoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 08:44:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jH8K5bbQLPjaD0fAq1zkCjeaksWZyNF696tOwEiaetvbjiw3mf/K/zYNZPW4i5rzbSVx2dCFjDQZJuJPBtdDRMWC42U1WdDx//AbDXoe/zlK1mT8hrk1juEwdSeAaVA9Kt/Eg47qXszCfcuPzAU3B6cLpNJyIFzTgdCBUE9dnbg=
Message-ID: <6264d2ec0708050544m2b74f480q8b9dcdadca92c600@mail.gmail.com>
Date: Sun, 5 Aug 2007 14:44:11 +0200
From: "=?ISO-8859-1?Q?Thomas_Lang=E5s?=" <thomas.langaas@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Disassembling a binary-only kernel module
Cc: thomas.langaas@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC me, as I'm not subscribed to the list.

I've got a binary-only kernel module for a box I own (PowerPC-based),
and I want to
disassemble the module but I don't know much about tools for linux for
doing this.

So, what I'm asking about is just a few pointers in which tools I should use for
the process.  (I've done a readelf for the initial insight on the module).

In advance, thanks!

-- 
Thomas
