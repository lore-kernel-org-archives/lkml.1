Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZKQWNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZKQWNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbZKQWNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:13:34 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:48383 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbZKQWNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:13:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=sN7CT9ctiNRNfoku6qjUKuUFL9kxH69Ygoodp+pKTG80VAJ7H7bHuvWtOZrba60wBQ
         W+0Svaw3wLLf3Jv9WjVCdex+Ff3LT5ONUtrUo13JsUemA6vwECFijEcJw7Ukeg0iApdB
         6lO9m6TvgBaTWOb+zBHsMLN/g3PWrMi0V50Wg=
MIME-Version: 1.0
In-Reply-To: <be7a9f3d0911171208w1474dfb3vacc2da9292657da@mail.gmail.com>
References: <be7a9f3d0911171208w1474dfb3vacc2da9292657da@mail.gmail.com>
Date: Tue, 17 Nov 2009 20:13:38 -0200
X-Google-Sender-Auth: de0937db9e741588
Message-ID: <be7a9f3d0911171413y3c34490er91fdb26b99d1868c@mail.gmail.com>
Subject: Re: [RFH] Vortex86SX: PCI address collision
From: Otavio Salvador <otavio@ossystems.com.br>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 17, 2009 at 6:08 PM, Otavio Salvador
<otavio@ossystems.com.br> wrote:
> I got this machine working booting it with "irqpoll" parameter however
> it drops the performance a lot and I'd like to try to fix the root
> problem of it.

I forgot to say that I tested it against both 2.6.31.5 and git HEAD
(a9366e61b03f55a6e009e687ad10e706714c9907).

-- 
Otavio Salvador                  O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854         http://projetos.ossystems.com.br
