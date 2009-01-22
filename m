Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbZAVK7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbZAVK7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 05:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZAVK7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 05:59:35 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:57262 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbZAVK7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 05:59:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=LsEq0DvWmckqLxYhw1RbKR3sQGmpB+/wdCvYq/7aeJTxZvOvrq7iSzTLeGk60EemG2
         91p5hQ40+m9bIRZJLbKOkiMIBOuqkmm3yf8AT/KjFormhcsF6rsElGoRfUq2ja5nhvrB
         C5KMOaWgyaap3m3dRAOdH7n1xrxLyGfVcSmHE=
MIME-Version: 1.0
Date: Thu, 22 Jan 2009 18:59:34 +0800
Message-ID: <4104961b0901220259u51677cbdkda2ed84dc2892543@mail.gmail.com>
Subject: How to generate a Kerntypes file?
From: jidong xiao <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,All,

Sometimes when I install a kernel I saw there is a Kerntypes file
installed under /boot directory, but sometimes no, I remember when I
install a sles9 kernel, there must be a Kerntypes file installed, but
most of other kernels doesn't include such a Kerntypes file. This file
is very useful for me to do some analysis, so I hope I can generate it
every time I build a kernel. Do I need a patch for this or there are
already some patches I can take use of?Thanks.

Regards
Jason
