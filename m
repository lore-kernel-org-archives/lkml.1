Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbZDZDYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbZDZDYl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 23:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZDZDYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 23:24:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:58867 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZDZDYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 23:24:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VSLhRxT7zwocpDrB3XciKMGNiYnqajbGTMNUTcn5XiZWU0fOcq6kISiQpZHyDMrwtj
         0Z4u+NFiV5x1cTuoHfEgq/GbC+zLPny4ZElCgvCbNnc2vqwAk/UAu1qDVe1BcCGD/ZI0
         LBzwIhmE3CBKCzXWbUOMpb38EDsU+XnTTfNfQ=
MIME-Version: 1.0
In-Reply-To: <Fg2zLW93smL.A.wAE.Xd48JB@chimera>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
	 <Fg2zLW93smL.A.wAE.Xd48JB@chimera>
Date: Sun, 26 Apr 2009 11:24:31 +0800
Message-ID: <b6a2187b0904252024w38530211icd4525e4d2c65dd6@mail.gmail.com>
Subject: Re: [Bug #13118] iptables very slow after commit 784544739a25c30637397ace5489eeb6e15d7d49
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Patrick McHardy <kaber@trash.net>,
       Stephen Hemminger <shemminger@vyatta.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 3:31 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13118
> Subject         : iptables very slow after commit 784544739a25c30637397ace5489eeb6e15d7d49
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Date            : 2009-04-10 16:05 (16 days old)
> References      : http://lkml.org/lkml/2009/4/10/111
> Handled-By      : Eric Dumazet <dada1@cosmosbay.com>

Several iteration of patches are in progress. Latest one being
http://lkml.org/lkml/2009/4/25/83

Thanks,
Jeff
