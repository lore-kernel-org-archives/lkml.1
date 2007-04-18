Return-Path: <linux-kernel-owner+w=401wt.eu-S2992452AbXDRNbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992452AbXDRNbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 09:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992466AbXDRNbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 09:31:39 -0400
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:38873 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992452AbXDRNbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 09:31:38 -0400
X-YMail-OSG: qPa0bh0VM1koFUiuP7gv.xkn1znq_PQx999nEuoertjSIfF5eNipScjvM06pLlRPnHy90Rn6dg--
X-RocketYMMF: rancidfat
Date: Wed, 18 Apr 2007 06:31:37 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: AppArmor FAQ
To: Joshua Brindle <jbrindle@tresys.com>, capibara@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <46260BE1.4060509@tresys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <262350.24656.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Joshua Brindle <jbrindle@tresys.com> wrote:


> Biba and BLP are only incompatible if they are using the same label, if 
> each object has a confidentiality and integrity label they work fine 
> together

Joshua is correct here, although the original Biba observation was
that flipping BLP upside down results in an integrity model. Trusted
Irix uses (used?) both Biba and BLP.

> (as well as MLS systems work in general that is).

Doh! He had to get the dig in.



Casey Schaufler
casey@schaufler-ca.com
