Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbZDAGJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbZDAGJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 02:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbZDAGI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 02:08:58 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:49156 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZDAGI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 02:08:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P1p6vu2R+b30OVRk3IzQoDqWv1AGRI2iYIZbNps1EgnN/8AqqIIcT6QtTwXDsEkryE
         X2iA19nfMckodE7XnBN6AbGSqYWf0PmR3jPXLXMHhVBDm80E9385gXR1tCSoF37p6+D9
         /+/uzOuV9a4/myunmKGqdWQIDNXeWFCMVJ5HI=
MIME-Version: 1.0
In-Reply-To: <1238564771.20906.26.camel@localhost.localdomain>
References: <200903260039.34013.david-b@pacbell.net>
	 <200903260042.50236.david-b@pacbell.net>
	 <1238564771.20906.26.camel@localhost.localdomain>
Date: Wed, 1 Apr 2009 10:08:54 +0400
Message-ID: <acd2a5930903312308j47f23c92h95816403a4254230@mail.gmail.com>
Subject: Re: [patch/rfc 2.6.29 2/2] MTD: support driver model updates
From: Vitaly Wool <vitalywool@gmail.com>
To: dedekind@infradead.org
Cc: David Brownell <david-b@pacbell.net>, Kay Sievers <kay.sievers@vrfy.org>,
       Linux MTD <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could this be done for all NANDs in nand_base.c instead?

Why would it be reasonable?

Thanks,
   Vitaly
