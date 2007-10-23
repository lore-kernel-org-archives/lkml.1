Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbXJWWbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbXJWWbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXJWWa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:30:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:63519 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbXJWWa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Nmld1ozP29ARgt+utdIE87Bj8jB0NR64xjdfZrqB12bNfE/oJIrMoxaivCBA6UkhQgiId0jZ+7l0po8y3wSGwOHsv9MjgeJtF27XHEsiZXlTq0Qx3j4G1bjQP2kJSujkf/6R0zDC8b3Cx5/RX+tKhGrJbm6zcYrcHbx493SkDBk=
Message-ID: <a4e6962a0710231530y60e4ab8elad9b88b085988012@mail.gmail.com>
Date: Tue, 23 Oct 2007 17:30:57 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] fs/9p/v9fs.c: memleak fix
Cc: "Latchesar Ionkov" <lucho@ionkov.net>,
       v9fs-developer@lists.sourceforge.net, rminnich@sandia.gov,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071019140530.GF3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071019140530.GF3778@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/07, Adrian Bunk <bunk@kernel.org> wrote:
> This patch fixes a memory leak introduced by
> commit ba17674fe02909fef049fd4b620a2805bdb8c693.
>
> Spotted by the Coverity checker.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Eric Van Hensbergen <ericvh@gmail.com>
