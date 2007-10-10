Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbXJJPuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbXJJPuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 11:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbXJJPuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 11:50:06 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:52893 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbXJJPuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 11:50:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YbwntkkqLOw9RHfY3yx04iETnh6Q2Nqmpwu/YCjAxJBtSZDIkCedSCGOzSCqLFG/5CBf2r5mQAKHuve/goAFlcrumMF/8rm88VhsVcVj1oJHH4AAPS9BisjtD1W9kE1Ch0p0eULAfpf94I0MXEk6s84CJJh16PjU92tIdNHtZ98=
Message-ID: <105610bf0710100850n2eb3c68codc3781d963df764e@mail.gmail.com>
Date: Wed, 10 Oct 2007 23:50:01 +0800
From: wit <is01kzh@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: about probing a device
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071010130923.004ee895@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <105610bf0710091839r3b2fc1bfp4260ceaf6ad94b7@mail.gmail.com>
	 <20071010130923.004ee895@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks very much.

> The first one which matches and successfully attaches "wins".

Seems that calling the bind routine can bind a driver to a device. Is
there any bad side effect of doing such thing?
