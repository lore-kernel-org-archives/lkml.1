Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbYIVKBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbYIVKBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 06:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbYIVKBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:01:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:55604 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbYIVKBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:01:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PmsNJ1F4Z8c1kMZrfvuumjU2ycGe3Ppwh+BvI4o3LMYAFYySz+kEYuf5fMrjYnJ9we
         O28Zv7duFqqFN7V+tm2nMWJO8kDOIlG+62Mg4/YeuFXKYra6DzHCZ/Eh6ESyuJxhohhb
         P3NXjSV9ZCLY7u3TvAuhdV0nuSQbT3ECsH4gM=
Message-ID: <86802c440809220301l662824aasa9cf3a437f42bd9@mail.gmail.com>
Date: Mon, 22 Sep 2008 03:01:38 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -tip/master] x86: io-apic - interrupt remapping fix
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
In-Reply-To: <20080922090405.GA12630@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080919123320.GF7222@lenovo> <20080922090405.GA12630@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 2:04 AM, Ingo Molnar <mingo@elte.hu> wrote:

BTW

x2apic and IRmapping make io_apic.c and apic.c ugly.

YH
