Return-Path: <linux-kernel-owner+w=401wt.eu-S1760395AbYCBVaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395AbYCBVaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 16:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbYCBVab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 16:30:31 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:51270 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbYCBVaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 16:30:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vPGIIOTPEJSaNGwJpu+wlAi2GrRlmvR/lk0atibca5v7UdPpmM0Pw/P9xpjWd/bDb/jUFR4A4dd1pUQ8q9bv0a0iGSSfYHnmWwBj8xTG1A+Ohw1wVXkbsAkKWi9eLaKILggeMSeITh7xSsS8Z0xNX/LNct3wC4GyslyW6xhYig4=
Message-ID: <aa79d98a0803021330r267414c8n5e4bee0161cfe0c1@mail.gmail.com>
Date: Mon, 3 Mar 2008 00:30:27 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slub: fix possible NULL pointer dereference
Cc: "Christoph Lameter" <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <84144f020803021248r53c3d179ga514c0c426e1e2d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080302202824.GA9032@cvg>
	 <84144f020803021248r53c3d179ga514c0c426e1e2d6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for review, Pekka, and sorry for not cc'ed you on initial
submittion (just missed :(
