Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbXFACVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbXFACVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 22:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbXFACVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 22:21:43 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:34542 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbXFACVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 22:21:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ge7I5IX3s4nCzz2+W+ppCLzhFJ2poe/jfpjee3luYs+0YzGvQ97M7vvarAZWejIuCU8xGDOX/IvGd77gy6rNlCe+5Blh7/8R06623WzjpeuzdaM+q27Q/0JaTfDBiEAFHWGgr+OmzFHz6Qe/UVfsRJExaIR7yn8+P6+yILDioTA=
Message-ID: <a8e1da0705311921v8bdec77vaa918efd9910e51b@mail.gmail.com>
Date: Fri, 1 Jun 2007 02:21:41 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch -mm] alsa mixer_oss kfree fix
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jaroslav Kysela" <perex@suse.cz>
In-Reply-To: <20070531191005.292efbdc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0705311853w4df1aae8k87c55fdfbfa96b10@mail.gmail.com>
	 <20070531191005.292efbdc.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> kfree(NULL) is legal, and is often used.

Really?  I don't know this before.

Regards
dave
