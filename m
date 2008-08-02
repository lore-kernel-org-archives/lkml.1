Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYHBXwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYHBXwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 19:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYHBXwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 19:52:05 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:17367 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYHBXwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 19:52:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cI2qOnlF2CNg7KFuMqipbv4QdJXQZAGWtqDQpsxCEptt2/Wm5ri+lJ8PnalHV6QTZK
         IoyyAnyvFXP8+8XKGZuH9s2OsN7U7PCGFUuoD0KPaS6Recm1J0whB3lqcnQ9sPtRcyKk
         CK4AoJ3vV4nehoZmBhUJnqwp7RipEyNIb9jNc=
Message-ID: <a4423d670808021652o28607891g12ca137858109449@mail.gmail.com>
Date: Sun, 3 Aug 2008 03:52:03 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] drivers/mtd/mtdsuper.c: fix build error
Cc: viro@zeniv.linux.org.uk, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080802234535.GA8929@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080802225304.GD4856@orion>
	 <20080802233240.GA4385@cs181140183.pp.htv.fi>
	 <a4423d670808021640he3ec660k1b5ddfcb6efd1ae5@mail.gmail.com>
	 <20080802234535.GA8929@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/3 Adrian Bunk <bunk@kernel.org>:
> You must store the config of the failed builds somewhere, since
> otherwise (like in this case) you cannot verify whether a patch
> actually fixes a problem.
Right, I have changed this script.
