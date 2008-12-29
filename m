Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbYL2Jlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbYL2Jlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 04:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYL2Jlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 04:41:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:15822 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYL2Jlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 04:41:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xw6MVUSJKkckAatSaIYD3tINc+YHM039ubspruEDUbDRSUktHnEiL68QVfxMJgEag5
         1RxplyrdSMFqJOZRcg+hlz20gkXZPxeOQNvIBvPSyyObSFcgoE4yE3bOinBbE24OJbuV
         ClU4RUND2lphljRW5VM+v79E6xQ146GZ8ZpFE=
Message-ID: <84144f020812290141m386769b9ia1e63ba85ebfe35@mail.gmail.com>
Date: Mon, 29 Dec 2008 11:41:37 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 0/3] kmemtrace over tracepoints
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Dipankar Sarma" <dipankar@in.ibm.com>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <cover.1230499486.git.eduard.munteanu@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cover.1230499486.git.eduard.munteanu@linux360.ro>
X-Google-Sender-Auth: d569c8cbae3a47f7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduard,

On Mon, Dec 29, 2008 at 3:40 AM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> Pekka, please merge this if it looks okay. I'll try to come up in time with
> the stuff described above; however, should I not be ready in time, please
> ask Linus to git-pull whatever we've got at present. Hopefully, it'll get
> in this time.

The RCU and tracepoint changes need an ACK from the relevant
maintainers before I can merge this. The conversion to tracepoints in
slab allocators looks good to me though.

                       Pekka
