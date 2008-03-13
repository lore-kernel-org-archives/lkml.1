Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYCMLsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYCMLsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 07:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYCMLsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 07:48:00 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:17562 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYCMLr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 07:47:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mRuWnqrlnqsCvUqXVN+SOFe5MroZHK7rBBtDD6LWtaoFIjcN/iw8xN3zUmYORGOQGAAYtBMsJGRulpq2ZYxMPVLlHR7UxtRpY7UskcuAvmo2ATgKnoqWflt2R8u445ia6NL5fpxnKjj3ONUGkDNMVv9np668CbATCncCvVNrxgo=
Message-ID: <80b317760803130447u6d1998ecv3fcbc018a37a7247@mail.gmail.com>
Date: Thu, 13 Mar 2008 12:47:58 +0100
From: "Richard Genoud" <richard.genoud@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [BUG] PLEXTOR DVDR PX-740A drive not ready for command
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <9ea470500803130255u3dbed41bwd02c16ea79a09152@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47D8F73F.4090501@gmail.com>
	 <9ea470500803130255u3dbed41bwd02c16ea79a09152@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Have you tried a more recent kernel? Your bisection interval is .23 and .24-rc1,
>  and a lot of code went into ide after that. However, you should try to
>  avoid 2.6.24
>  since ide-cd was broken there. I'd go with 2.6.25-rc5, for example.

I did not tried it personnaly, but at least 2 persons on the ubuntu
bug tracker did.
The bug is still there.
