Return-Path: <linux-kernel-owner+w=401wt.eu-S1751839AbXBBJdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbXBBJdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 04:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXBBJdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 04:33:42 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:52065 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbXBBJdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 04:33:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lGYlvkJ46etzPSR5vpdzllMYyJvc8FVFnJeC5IHK1m9e6jdMLji1AT42lJwEk1EFGAljWE0KEZz8XB/ju5v23igGEboNdtEfhragOHj2qna93NBr9h/Pzf0C6wimbXo508hfAH9kyQ7YYoK/4+5MZoBsIWaSYzJgM65RwEQxZXU=
Message-ID: <e9f486400702020133h669c4f2ci908f952b22ddcf49@mail.gmail.com>
Date: Fri, 2 Feb 2007 10:33:40 +0100
From: "Henri Hunnekens" <henrihunnekens@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20-RC7-RT3 compiler error
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've the following compiler error:

linux-2.6.20.i686/arch/i386/mm/pgtable.c:303: undefined reference to
`paravirt_enabled'
linux-2.6.20.i686/arch/i386/mm/pgtable.c:306: undefined reference to `hypercall'
Error 1

Is there anyone who knows what causes this error?

Henri
