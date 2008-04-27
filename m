Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbYD0Clj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbYD0Clj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 22:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYD0Cla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 22:41:30 -0400
Received: from rv-out-0708.google.com ([209.85.198.250]:36575 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753165AbYD0Cl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 22:41:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=OOH+QZw0fXnxWYUg1GqSAYtUUSzi/rJ6iADEF2AfGrpmUIWk4rTSOn/kTeJOVV2ErTCqK8VcgKYTGYqgE+bRR57jmXl8ea3bOiuHTvwAFmEE0Eya59r6AJYW6ws4PbxxM89xAb6Y+IB1YVfjdezps5YbMI3+6FddAGUvFQAU1zU=
Message-ID: <b6c5339f0804261941n1a25d37axe17c413fca481e18@mail.gmail.com>
Date: Sat, 26 Apr 2008 22:41:29 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: spinlock lockup on CPU#0
Cc: "Bernard Pidoux" <bpidoux@free.fr>, linux-kernel@vger.kernel.org
In-Reply-To: <dd18b0c30804261920o3bd3c7c3ud5969981f5f7d18e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804262333.39383.bpidoux@free.fr>
	 <200804270215.23739.bpidoux@free.fr>
	 <dd18b0c30804261900m1a2edebld6a796e1de85c19e@mail.gmail.com>
	 <b6c5339f0804261913l4e3b6aacsa1e9db120d8fed8b@mail.gmail.com>
	 <dd18b0c30804261920o3bd3c7c3ud5969981f5f7d18e@mail.gmail.com>
X-Google-Sender-Auth: 1c69152a0f07f318
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 10:20 PM, Justin Mattock
<justinmattock@gmail.com> wrote:
>
>  I'll have to give that a try, the number for my card is: AR5418
>  If there is'nt any support, then I'll have to use the ndiswrapper approach
>  for the time being as a quick solution, or revert to my backup kernel

Ah, I am using AR5006 which is a 5424, so ymmv.

-- 
Bob Copeland %% www.bobcopeland.com
