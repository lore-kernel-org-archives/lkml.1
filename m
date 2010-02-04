Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab0BDSaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:30:05 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:54757 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab0BDSaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:30:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=P23kG+n0yqNUVTUv9j5KK1VVgI7HsT54ymkJjIYu4OXwoiO1rCHJaEYswcBkBB9NZJ
         ZsAwYc6k7mpOr/FFrATXnPU66vSsI05TXW3E1vErWBEZ5J4i6n9m+0U0AIItGCZGCt1k
         YHs/jteopm070tGAiGEqvNjaQR66ML9JZYuwg=
Subject: Re: patch net-restore-ip-source-validation.patch added to
 2.6.32-stable tree
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: David Miller <davem@davemloft.net>
Cc: s.L-H@gmx.de, gregkh@suse.de, linux-kernel@vger.kernel.org,
       stable@kernel.org
In-Reply-To: <20100204.101916.180396428.davem@davemloft.net>
References: <1265282011.4204.12.camel@bigi>
	 <201002041850.31310.s.L-H@gmx.de> <1265307247.4651.2.camel@bigi>
	 <20100204.101916.180396428.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 04 Feb 2010 13:29:55 -0500
Message-Id: <1265308195.4651.10.camel@bigi>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 10:19 -0800, David Miller wrote:

> 
> Do they really have to be contiguous?  That's a strange
> requirement.
> 

It would be strange indeed - so that was a wild guess; still a variable
from what i tested this morning. I wonder if making it contigous would
show different results.

cheers,
jamal

