Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYKXUNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYKXUNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYKXUNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:13:22 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:38424 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYKXUNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:13:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Tpfo9GeG3iums/bPnZMNehmIFcIeXKJ5jQ3mYXLbVNzY2sGqAsT+cY16kapteVO9eR
         pPfLR1bdHqa2MezB/fgXTsx6JfJyVh6AHMdb+PNHyD2qNZ752sU082fe/ktS6Cou6F2F
         lupUjuVKkolSnYyoUg4fPs/AwFHYqNSTt6lnI=
Message-ID: <c62985530811241213k2812db8k5723f459a2d00aec@mail.gmail.com>
Date: Mon, 24 Nov 2008 21:13:20 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Arnaldo Carvalho de Melo" <acme@redhat.com>,
       "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: Human readable output for function return tracer
In-Reply-To: <20081124193954.GI26466@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c62985530811240639w574659c0nd0a54e6c1fb1197a@mail.gmail.com>
	 <20081124181515.GG26466@ghostprotocols.net>
	 <c62985530811241110o32a601ddud0cfc02a9767a7d8@mail.gmail.com>
	 <20081124193954.GI26466@ghostprotocols.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/24 Arnaldo Carvalho de Melo <acme@redhat.com>:
> Well, you can record, for each entry, the thread id, but then you will
> not know to what file, say, a close operation relates to.


Oh ok, I see...yes. Hmm, I will see later, when the output will be...stable.
