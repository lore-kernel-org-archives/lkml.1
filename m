Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbYGRNwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbYGRNwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbYGRNw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:52:26 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:62921 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699AbYGRNwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:52:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=O/MBKn1a3KkYx0L8zIAP1FaGWaBYrHmZpHLYC3mEQKRdpKqaJ+vLSrOUvOQ6A6apPW
         3ppgteoCWWMn0hKSn13hGOAN6vnMiJAFLrAtoO/0mtF/Z4JCR0jegGBQGjr7KehoAdAj
         wZsABEgU8ZF579Smnvp3lNNPCTcjEq7EgWKSA=
Message-ID: <a4423d670807180652y352e66lfe04d2b33d2ed176@mail.gmail.com>
Date: Fri, 18 Jul 2008 17:52:23 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: Tree for July 17: early crash on x86-64
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <200807180106.08328.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080718012842.690b8346.sfr@canb.auug.org.au>
	 <200807180106.08328.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/18 Rafael J. Wysocki <rjw@sisk.pl>:
> This one crashes all of my x86-64 test boxes early during boot.
The same problem with next-20080718.
Unfortunatelly I do not have serial console on that host.
