Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbZCLHLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbZCLHLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZCLHLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:11:10 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:49439 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbZCLHLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:11:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wQeZmIdqJDikMw63nZe9dmJDGLCEQ5gND1YYabsfBQosZpvM+KMNQNGK5NHJmw7yVU
         T3lOKrWrCQbghWL0ioOjekHGSvAyfSjHdBFCnqIYR7Lpdmo5EvXut9dqbinLyaiCYmKE
         8iNSTn3IVVsyumXeOEzRwWgZITP1YtB5iB4M0=
MIME-Version: 1.0
In-Reply-To: <49B8B1FB.1040506@cn.fujitsu.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com>
	 <49B8810B.7030603@oss.ntt.co.jp>
	 <d95d44a20903112340s3c77807dt465e68901747ad89@mail.gmail.com>
	 <49B8B1FB.1040506@cn.fujitsu.com>
Date: Thu, 12 Mar 2009 15:11:07 +0800
Message-ID: <d95d44a20903120011m4a7281enf17b31b9aaf7c937@mail.gmail.com>
Subject: Re: [RFC] IO Controller
From: anqin <anqin.qin@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       Vivek Goyal <vgoyal@redhat.com>, oz-kernel@redhat.com,
       paolo.valente@unimore.it, linux-kernel@vger.kernel.org,
       dhaval@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       menage@google.com, jmoyer@redhat.com, fchecconi@gmail.com,
       arozansk@redhat.com, jens.axboe@oracle.com, akpm@linux-foundation.org,
       fernando@intellilink.co.jp, balbir@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why? When this is ready to be merged, then it should be based on Jens' block-tree,
> or akpm's mm tree. And this version currently is based on 2.6.29-rc4, so if you
> want to try it out, just prepare a 2.6.29-rc4 kernel tree.
>

I have checked the LKML and see these patches (on web pages) are based on
2.6.27. It seemed too old.

You mean that the codes have new patch files in 2.6.29-rc4?
