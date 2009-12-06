Return-Path: <linux-kernel-owner+w=401wt.eu-S934353AbZLFWWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934353AbZLFWWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 17:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934332AbZLFWWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 17:22:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:61991 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934318AbZLFWWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 17:22:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UwJmXfEkfnPiJi3K0Xu3ksgekcFXVLXVAq5MM/JRW/yYkwDKC5y6lsi/i3r3kTkPP8
         zXMQtKfKnf4QLiMZ7SgUcMalI2KzCRIiJSltOO9h0pOHja3bMHqE6i10ugVC/Z6h74tr
         8sEg3A+9CuDzFM0YSbRox1UqG7Ddn8nvB/rcE=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0912061705050.9883-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0912061705050.9883-100000@netrider.rowland.org>
Date: Sun, 6 Dec 2009 20:22:57 -0200
X-Google-Sender-Auth: a2e56fde924fdd54
Message-ID: <be7a9f3d0912061422x5a0fd2f6ubd7add33472a8136@mail.gmail.com>
Subject: Re: REGRESSION for RT2561/RT61 in 2.6.32
From: Otavio Salvador <otavio@ossystems.com.br>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-wireless@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan,

On Sun, Dec 6, 2009 at 8:12 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> When I use 2.6.32 (or indeed 2.6.32-rc1), it works fine up until the
> point where the wireless card is ifconfig'ed.  Then not long afterward
> (a few seconds to a minute) the system hangs.

Did you test it with 2.6.32? Since 2.6.32-rc1 many fixes has been done
into kernel and would be nice if you could test against current
kernel.

Cheers,

-- 
Otavio Salvador                  O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854         http://projetos.ossystems.com.br
