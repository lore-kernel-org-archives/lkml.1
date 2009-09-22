Return-Path: <linux-kernel-owner+w=401wt.eu-S1751941AbZIVThS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbZIVThS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbZIVThP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:37:15 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57305 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZIVThO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:37:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=wWxWRObx4TINqSjx8iHWJrv8ez9mSN2rqCDDh7WsSJmVXS+l3pgnk5Dg/TxX8oxTqR
         PcSlaqIwteVpc4Kb3LKpicivqk7tV/yqZxB8ZP8lVRjxPkjbK/U8R0EXz2+Xl0yYgyUH
         ohHo10NT4MwQDHcD0MA73BKfVVWSoOyRu3JnE=
MIME-Version: 1.0
Reply-To: gabe@blackfam.net
In-Reply-To: <20090922211101.076e9763@infradead.org>
References: <8a15eb2b0909221201k70b9e9darc6fda53f87bfae29@mail.gmail.com>
	 <20090922211101.076e9763@infradead.org>
Date: Tue, 22 Sep 2009 14:37:16 -0500
Message-ID: <8a15eb2b0909221237s5d3e408do4e3bed8aaaa337a8@mail.gmail.com>
Subject: Re: TI PCIe-PCI bridge quirks
From: Gabe Black <gabebblack@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 2:11 PM, Arjan van de Ven <arjan@infradead.org> wrote:
>
> sounds like this is worth a PCI quirk in the kernel...
>

Is there documentation on how one would go about writing a "PCI quirk"?

Thanks,
Gabe
