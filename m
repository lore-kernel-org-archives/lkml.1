Return-Path: <linux-kernel-owner+w=401wt.eu-S932600AbXCEJvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbXCEJvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 04:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXCEJvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 04:51:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:35037 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600AbXCEJvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 04:51:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d5+MfmjoKQ0Ifv9kIZrZ7txQP+n0XUDDD1JCZYBZGr5kUrHTF7M90w+ZhdFhuSVUEgpJCZjMPzR7kRNWpicw4QHfVfvtVMGB2oiJG7xjsBTOo3MyPsiN36vI4shgh8W98kKJt/bcoGalH7DdRY0BzbLwvTbk8AACOkEwIoaFHAc=
Message-ID: <29c147bd0703050151v42aafc81qddce8cc6b605febb@mail.gmail.com>
Date: Mon, 5 Mar 2007 10:51:16 +0100
From: "Lorenzo Milesi" <lorenzo.milesi@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: Problem with skbuff.c
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070305.011220.112620254.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <29c147bd0703050032k71a06603p89d541071be5d656@mail.gmail.com>
	 <20070305.004436.41635733.davem@davemloft.net>
	 <29c147bd0703050052x7c8dca4esfc51b66c67b01cb1@mail.gmail.com>
	 <20070305.011220.112620254.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It just means there is a miscalculation somewhere else,
> because the bug that patch was meant to fix was cured
> by a different fix.

Guessed so....
Can I do something to dig the problem?

Thanks
maxxer
