Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbXHAPv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbXHAPv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbXHAPvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:51:50 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:64722 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbXHAPvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:51:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hha0FyLcfaIMcsDrsipktIVWEOncBysMgQCpgIdX+hjMswUmdJe2QrgDtfsUfzzHWwym+s0+zfpYLe4HWUX6jEq+NmVt5eCOoKqIKj7YmqTiWkrLuc/oxkYb7qBGKqQZTt/8vmiPwx9RNKCLnPNYuwPSMDUuo5Q5dc5Zy7f2DDc=
Message-ID: <40378e40708010851q48d73e36v3b1d468aa7712284@mail.gmail.com>
Date: Wed, 1 Aug 2007 17:51:45 +0200
From: "Mohamed Bamakhrama" <bamakhrama@gmail.com>
Reply-To: bamakhrama@gmail.com
To: linux-kernel@vger.kernel.org
Subject: Profiling the Kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi *,
I have a question regarding profiling the Linux kernel code during
runtime (by "profile", I mean the usage of each function/module within
the kernel itself). I googled and found many "system-wide" profiler
such as sysprof, Oprofile, etc... I am working on an embedded system
project and currently we are using an on-chip debugger which
interfaces with the system through EJTAG port. All what it can provide
is just a "uniform sampling" of the kernel code usage and according to
the manufacturer, it is not a safe way to determine the "hot spots"
within the kernel. Does anyone know about any hardware/software tool
that can provide a "good" profile of the kernel code usage?

Thanks in advance.

Best regards,

-- 
Mohamed A. Bamakhrama
Web: http://home.cs.tum.edu/~bamakhra/
