Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbYIEEaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbYIEEaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 00:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbYIEEaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 00:30:01 -0400
Received: from relay2.sgi.com ([192.48.171.30]:44366 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750720AbYIEEaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 00:30:01 -0400
Date: Thu, 4 Sep 2008 23:29:58 -0500
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       jh@sgi.com
Subject: Re: [PATCH] cpuset: hotplug documentation fix
Message-Id: <20080904232958.6ac79ada.pj@sgi.com>
In-Reply-To: <48C0AAF8.605@cn.fujitsu.com>
References: <48C0AAF8.605@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for updating this, Li Zefan.

I would suggest one minor wording fix.  The past tense of bind is bound.
(Don't you just love how regular the English language is ;)?

So, replace:
  +cpuset is binded with another cgroup subsystem which has some restrictions
with:
  +cpuset is bound with another cgroup subsystem which has some restrictions

Either way:

Acked-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
