Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbZLIWdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbZLIWdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758279AbZLIWdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:33:05 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:41556 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270AbZLIWdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:33:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=CVkYeUwRH4gjqn24dRx0tbs2O937wUH8E++iTmn7KZjqNa0N7HJSL+UfkIUHMQEL5b
         JAdWaK1Kxw7qPqiU+oHLyVDCSyrvV/lqlK5xPAOA2s0fJIjrRfdMbiTc+dXzdfzx7HMM
         ga8Ew1h3iEqfHcwO5HTKTpIRlOpwh/6DRVOPU=
MIME-Version: 1.0
In-Reply-To: <4B201D67.8000607@gmail.com>
References: <Pine.LNX.4.44L0.0912090940030.4120-100000@iolanthe.rowland.org>
	 <4B201D67.8000607@gmail.com>
Date: Wed, 9 Dec 2009 20:33:08 -0200
X-Google-Sender-Auth: 706a05449143ec81
Message-ID: <be7a9f3d0912091433s437859a4k873fb147e1763c46@mail.gmail.com>
Subject: Re: REGRESSION for RT2561/RT61 in 2.6.32
From: Otavio Salvador <otavio@ossystems.com.br>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Ivo van Doorn <IvDoorn@gmail.com>,
       linux-wireless@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 9, 2009 at 7:57 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Thanks for testing and confirming.
>
> I'll disable powersaving for rt2x00 for now.

It would be nice to have it in 2.6.32.y and 2.6.31.y when it is done.

-- 
Otavio Salvador                  O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854         http://projetos.ossystems.com.br
