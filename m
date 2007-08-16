Return-Path: <linux-kernel-owner+w=401wt.eu-S936343AbXHPDPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936343AbXHPDPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 23:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756585AbXHPDPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 23:15:45 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:47383 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755067AbXHPDPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 23:15:44 -0400
Message-ID: <387234139.16356@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 16 Aug 2007 11:15:39 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Matt Mackall <mpm@selenic.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       John Berthels <jjberthels@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH] /proc/<pid>/pmaps - memory maps in granularity of
	pages
Message-ID: <20070816031539.GA5110@mail.ustc.edu.cn>
References: <20070814085204.GA10884@mail.ustc.edu.cn> <20070814162618.GV30556@waste.org> <20070816013701.GA5209@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816013701.GA5209@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 09:37:01AM +0800, Fengguang Wu wrote:
> 3) A 64bit number can be encoded in hex in 8 bytes, no more than its
                                             ~~ sorry, I'm a fool!
> binary presentation. And often the text string will be much shorter
> because of the common small values.

