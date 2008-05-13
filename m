Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbYEMCmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbYEMCmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 22:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbYEMCmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 22:42:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55774 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750969AbYEMCmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 22:42:24 -0400
Date: Mon, 12 May 2008 21:42:24 -0500
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: lizf@cn.fujitsu.com, akpm@linux-foundation.org,
       seto.hidetoshi@jp.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: limit the input of
 cpuset.sched_relax_domain_level
Message-Id: <20080512214224.52bbeb71.pj@sgi.com>
In-Reply-To: <6599ad830805121929q6746d6b3ye96196e567bc0150@mail.gmail.com>
References: <4828FC85.7020400@cn.fujitsu.com>
	<6599ad830805121929q6746d6b3ye96196e567bc0150@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 7:27 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> We allow the inputs to be [-1 ... SD_LV_MAX), and return -EINVAL
>  for inputs outside this range.

pj replied with a "signed-off-by"

Oops -- wrong response.  Let's try:

Acked-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
