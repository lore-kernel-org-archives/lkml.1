Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbZBKOEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbZBKOEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbZBKOE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:04:29 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:60391 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644AbZBKOE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:04:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=plafmuNoavpnWNydAQkPg6OR+9TgVpHePFSrYBqxxDBtJOxoKqcUrB0MrefA4sKolU
         qFGyk8OdVUOZ9aEKFx809aJm7/sSVW9tX2Dx5ACP/ezqmFMJoVM7Aqxu8dh1FqQCi9Y4
         EuTDld9H193hxyM0JFcSPozIducNzjZOgJpis=
MIME-Version: 1.0
In-Reply-To: <31230.1234357767@redhat.com>
References: <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <27780.1234356078@redhat.com>
	 <20090211214639.C3D0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <31230.1234357767@redhat.com>
Date: Wed, 11 Feb 2009 23:04:26 +0900
X-Google-Sender-Auth: ba2180a3627f19f7
Message-ID: <2f11576a0902110604s525b3635yebe42aeef0e28ee3@mail.gmail.com>
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>
Cc: Serge Hallyn <serue@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>
> Can you see the attached patch?  You'll need to turn on
> CONFIG_DEBUG_POISONED_PUT and you should keep CONFIG_DEBUG_SLAB on too.
>
> I haven't tried compiling it for IA64, so the header change I made for that
> may not compile.

maybe I can. but I can't do today.
it because now is midnight in japan ;)

please wait until tomorrow.
