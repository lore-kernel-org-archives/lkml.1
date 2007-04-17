Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbXDQN7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbXDQN7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbXDQN7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:59:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:38759 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbXDQN7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:59:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U9KBv3TKb9pQO1fo0dfHYI4+rAYgMqAseG7WGMUB1XmltmWQpT/VKzuQc1lGY28SRXFde/YhkQffjXCIVMFLizcdsMZh6WusAVTfcSqPrdgNbNWVW4uqQPfpFbxfaJQYnytpYUhXDSauRA4ng2mvg4bCFDokOMaUV31ShPjGOmE=
Message-ID: <38b2ab8a0704170659o3f65f5fbo94a59be58727d21c@mail.gmail.com>
Date: Tue, 17 Apr 2007 15:59:29 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] is it really optimized ?
Cc: helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
In-Reply-To: <E1HdnvW-0005Ti-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0704170536x15920b15xedfd518cad50cee@mail.gmail.com>
	 <E1HdnvW-0005Ti-00@gondolin.me.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/17/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Actually, I was referring to your AES module :)
>

Well I don't if I can do that unfortunately.

Actually there's nothing really interesting in this code, only key or
acc loadings and that's it.

What do you want to see exactly ?

Thanks
-- 
Francis
