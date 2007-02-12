Return-Path: <linux-kernel-owner+w=401wt.eu-S964814AbXBLJYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814AbXBLJYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964816AbXBLJYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:24:48 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:28061 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964814AbXBLJYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:24:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b6mTZbw0yUa07EWTx9G1bVFnsJgyZRJAQ/zog7lzT2oK1Dihv4MC/s2H17DTKZu6PrXMye9keoqeWSZKYqi3cTMiDvUgyERkJmyTKcV0Ga7slyFITQAQl6Fwyd5oSWTSmhCDmXdg5lNMy3Uaxu3ughnEmnf5LDscoxkF4CaqHd0=
Message-ID: <b6a2187b0702120124h7b291041t5717aafc675859db@mail.gmail.com>
Date: Mon, 12 Feb 2007 17:24:45 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [QUESTION] file access time in millisecond?
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1171267260.3081.32.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0702112327t7294c221w460b3bd0f77d0e@mail.gmail.com>
	 <1171267260.3081.32.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/07, Arjan van de Ven <arjan@infradead.org> wrote:

> see the "utimes()" function

Arjan,

I checked the man page, and it says ...

utime, utimes - change access and/or modification times of an inode

I just want to "read" the access time, and not changing it.

Thanks,

Jeff.
