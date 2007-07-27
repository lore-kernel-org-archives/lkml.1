Return-Path: <linux-kernel-owner+w=401wt.eu-S933456AbXG0TTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456AbXG0TTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759980AbXG0TTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:19:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49382 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758228AbXG0TTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:19:39 -0400
Date: Fri, 27 Jul 2007 12:19:30 -0700
From: Paul Jackson <pj@sgi.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: mingo@elte.hu, akpm@linux-foundation.org, frank@kingswood-consulting.co.uk,
       andi@firstfloor.org, nickpiggin@yahoo.com.au, ray-lk@madrabbit.org,
       jesper.juhl@gmail.com, ck@vds.kolivas.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans
 for 2.6.23]
Message-Id: <20070727121930.30779cad.pj@sgi.com>
In-Reply-To: <20070726102025.GJ27237@ftp.linux.org.uk>
References: <46A57068.3070701@yahoo.com.au>
	<2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	<46A58B49.3050508@yahoo.com.au>
	<2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	<46A6CC56.6040307@yahoo.com.au>
	<p73abtkrz37.fsf@bingen.suse.de>
	<46A85D95.509@kingswood-consulting.co.uk>
	<20070726092025.GA9157@elte.hu>
	<20070726023401.f6a2fbdf.akpm@linux-foundation.org>
	<20070726094024.GA15583@elte.hu>
	<20070726102025.GJ27237@ftp.linux.org.uk>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> BTW, I really wonder how much pain could be avoided if updatedb recorded
> mtime of directories and checked it.

Someone mentioned a variant of slocate above that they called mlocate,
and that Red Hat ships, that seems to do this (if I understand you and
what mlocate does correctly.)

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
