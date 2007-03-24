Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbXCXSGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbXCXSGF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 14:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXCXSGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 14:06:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:58888 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbXCXSGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 14:06:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=bzk9zyqY1wZbCTQamjTF2N7IxGLBEGTgGp7hMrWHudOsUx7yGwl1KgOl6eoIvqO91WlwmzCs+k8xL5FujcMqIQH4R8KEu4SlHwR+4Q0ROBBsdv64zjpK+zqbDbyCEblzOJ9ZBX1NgDoRVEgN3W2Otv15yBydfL9LG4mL6prgmRA=
Message-ID: <f36b08ee0703241106n7b8dd952p46d16a7c41abb4cd@mail.gmail.com>
Date: Sat, 24 Mar 2007 20:06:00 +0200
From: "Yakov Lerner" <iler.ml@gmail.com>
To: "Kernel Linux" <linux-kernel@vger.kernel.org>
Subject: glibc vs 2.6/2.4
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can I build recent glibc such that it will work both on
2.6 and on 2.4 ? (multithreading-wise, I suppose). I tried
to boot recent 2.6-based distro with 2.4 kernel and it did not work.

Do I need to set some env.vars maybe (LD_ASSUME_KERNEL ?
GNU_LIBPTHREAD_VERSION ?) for glibc when I switch kernels ?

Yakov Lerner
