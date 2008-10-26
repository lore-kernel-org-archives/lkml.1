Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYJZPGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYJZPGq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 11:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbYJZPGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 11:06:38 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:2651 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbYJZPGh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 11:06:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZAJO1ZyrPkXcTDntQWYzE8j3sWSt1Wnv+QnExmXETWqK3qDV5Mim2Ysv7L299z+RpN
         rl8IGUzLTAaehNfTsuCYe5ynY/RDDCAWHvSeaKjkn+daxedUlyfaahE7L3bDy2QsJjka
         Qe9tZ9ZHuY8OO5CRZQu1tFEh4zFQyE+NLFt3g=
Message-ID: <c62985530810260806t75f257c9q9ffcdda09d58bcbc@mail.gmail.com>
Date: Sun, 26 Oct 2008 16:06:36 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "=?ISO-8859-1?Q?T=F6r=F6k_Edwin?=" <edwintorok@gmail.com>
Subject: Re: [PATCH 1/4] Add support for userspace stacktraces in tracing/iter_ctrl
Cc: mingo@elte.hu, srostedt@redhat.com, a.p.zijlstra@chello.nl,
       sandmann@daimi.au.dk, linux-kernel@vger.kernel.org
In-Reply-To: <4904164F.5090006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>
	 <1223817124-27239-3-git-send-email-edwintorok@gmail.com>
	 <c62985530810252105k3bce2339k5a49c09fa502ac67@mail.gmail.com>
	 <4904164F.5090006@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/26 Török Edwin <edwintorok@gmail.com>:
> Hi,
>
> The stacktrace code itself is in the arch directory, did I miss anything
> else that should belong there?

No, that's my bad, I misread the patch. Sorry :)
