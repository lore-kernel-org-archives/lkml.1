Return-Path: <linux-kernel-owner+w=401wt.eu-S1763889AbXLUBCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763889AbXLUBCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 20:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbXLUBCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:02:31 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:52524 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbXLUBCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:02:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BGxLlU5ykqrsDgQhP0eE+dobMvFk9q+bjTFiogmKbeFesHEtfcaV9Ys1z6cJ0N4FbTP2OUdrmiIUswiL89ysT58EmzLvX78ITOb0jj8ZvpKEBEYmH9lFm7mSDqo3nBCb7qQCrlJftvumJui5l2E3oYGuEu/GHISuBJWETveFRls=
Message-ID: <8bd0f97a0712201702y3621f60cvf165e41f61ed913c@mail.gmail.com>
Date: Thu, 20 Dec 2007 20:02:30 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Josh Boyer" <jwboyer@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2/3] Rework arch specific Makefiles to use mkimage
Cc: linux-kernel@vger.kernel.org, paulus@samba.org
In-Reply-To: <20071220101829.44ca59da@zod.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071220101643.48b427ef@zod.rchland.ibm.com>
	 <20071220101829.44ca59da@zod.rchland.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 20, 2007 11:18 AM, Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:
> Rework the architecture specific Makefiles to use the in-kernel version
> of the mkimage tool.
>
> Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
>
>  arch/blackfin/boot/Makefile     |    4 ++--

we dont particularlly care one way or the other as it really makes no
difference to us :)
-mike
