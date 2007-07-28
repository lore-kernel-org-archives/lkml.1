Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbXG1GBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbXG1GBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 02:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbXG1GA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 02:00:56 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:54751 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbXG1GA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 02:00:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NArMffj8SHuRRFNWe3Qc4et1ptw0q2nsSlvpiVRwzFo1WcU0pMATY1rxWvoB4alTVScsX+4umN5WICqRHcZnzA4EdfYwe7EoCAnpfRsIzo9uQu/9dob6RCZ5pXnRfdScxSxDLGYnCaFNS/kSfmpzAYD2noaVnYtl9mPhShHhQa4=
Message-ID: <a44ae5cd0707272300y85825d0v9b8ff60de0de50a0@mail.gmail.com>
Date: Fri, 27 Jul 2007 23:00:54 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: =?WINDOWS-1252?Q?mm/sparse.c:482:_error:_implicit_declarati?= =?WINDOWS-1252?Q?on_of_function_=91sparse=5Fearly=5Fusemap=5Falloc=92?=
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do you need my .config file?

  CC      mm/sparse.o
mm/sparse.c: In function 'sparse_init':
mm/sparse.c:482: error: implicit declaration of function
'sparse_early_usemap_alloc'
mm/sparse.c:482: warning: assignment makes pointer from integer without a cast
make[1]: *** [mm/sparse.o] Error 1
