Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbZCGJNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbZCGJNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 04:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZCGJNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 04:13:38 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:42091 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbZCGJNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 04:13:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VdXmefMdw6xqQDhhsU8HLHS1UqGhJmUlGb7SrgphD6Xg9phAfHrfzRLVySbM3034Cd
         +WgODZOmNXkXOUt4ZhHu3xcmTFiiWN2vVDU9GHB9Dl+YCCQ1yR2aA2usGu7fAb4fvZ5g
         cTztEjTqfxKZ58WCO4nQJj/CcTLculZYWZ7bg=
Message-ID: <49B23ABC.7030304@gmail.com>
Date: Sat, 07 Mar 2009 10:13:32 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add function spin_event_timeout()
References: <1236384801-10305-1-git-send-email-timur@freescale.com>	 <adaiqmmf87v.fsf@cisco.com> <ed82fe3e0903061725y40dc246ehd3482690ee3898fa@mail.gmail.com>
In-Reply-To: <ed82fe3e0903061725y40dc246ehd3482690ee3898fa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7.3.2009 02:25, Timur Tabi wrote:
> Ok.  I'll post version 2 on Monday.  Anything else I'm missing?

Use time_after().

