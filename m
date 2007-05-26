Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbXEZXsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbXEZXsO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 19:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbXEZXsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 19:48:00 -0400
Received: from gw.goop.org ([64.81.55.164]:58784 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbXEZXr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 19:47:59 -0400
Message-ID: <4658C72E.9030205@goop.org>
Date: Sun, 27 May 2007 00:47:58 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Chris Wright <chrisw@sous-sol.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Extending boot protocol & bzImage for paravirt_ops
References: <4656FB8F.4090604@goop.org>	 <m14pm0c0m2.fsf@ebiederm.dsl.xmission.com> <1180174691.650.8.camel@localhost.localdomain>
In-Reply-To: <1180174691.650.8.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> You also want to skip the cli: perhaps a separate flag for this is
> appropriate though.
>   

Not a problem for Xen; it will be trapped+emulated (ie, ignored).

    J
