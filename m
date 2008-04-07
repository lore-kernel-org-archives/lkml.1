Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbYDGIEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbYDGIEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 04:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbYDGIE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 04:04:26 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50965 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753106AbYDGIE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 04:04:26 -0400
Date: Mon, 7 Apr 2008 03:04:21 -0500
From: Paul Jackson <pj@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: add cpus_scnprintf function v2
Message-Id: <20080407030421.0c3f8033.pj@sgi.com>
In-Reply-To: <20080405012447.440875000@polaris-admin.engr.sgi.com>
References: <20080405012447.440875000@polaris-admin.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I still have some concerns with this cpus_scnprintf patch. 

I've taken them up with Mike offline for initial consideration.

If others have questions, concerns or enthusiasms for this patch,
Mike and I would be interested.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
