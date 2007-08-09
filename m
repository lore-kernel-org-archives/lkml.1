Return-Path: <linux-kernel-owner+w=401wt.eu-S965434AbXHIOSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965434AbXHIOSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934475AbXHIOST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:18:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:20016 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940625AbXHIOSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:18:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=C61f0SXlYOgfybALxOjdjNHshbtpqpmL55ayvMR8KrtEThb4dmb+tWvLF+zL2lTWSs4UiWmSxurPIdHdDjgIxe8GSh1hdflBGxYUyzyQebJwy9TbZw/sS13UaxXPyStPY6ds7esEFMLZALOwlVHK5SAnkGP8440jraidzIla5+M=
Message-ID: <a44ae5cd0708090718v5dc19572k69087f170f9ba857@mail.gmail.com>
Date: Thu, 9 Aug 2007 10:18:15 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: =?WINDOWS-1252?Q?2.6.23-rc2-mm1_--_drivers/dma/ioat=5Fdca.c:177:_error?= =?WINDOWS-1252?Q?:_implicit_declaration_of_?= =?WINDOWS-1252?Q?function_=91cpu=5Fphysical=5Fid=92?=
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      drivers/dma/ioat_dca.o
drivers/dma/ioat_dca.c: In function 'ioat_dca_get_tag':
drivers/dma/ioat_dca.c:177: error: implicit declaration of function
'cpu_physical_id'
make[2]: *** [drivers/dma/ioat_dca.o] Error 1
