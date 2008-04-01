Return-Path: <linux-kernel-owner+w=401wt.eu-S1760069AbYDAWdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069AbYDAWdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 18:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbYDAWdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 18:33:06 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48288 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbYDAWdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 18:33:04 -0400
Subject: Re: [ANNOUNCE] Btrfs v0.13
From: Badari Pulavarty <pbadari@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       btrfs-devel@oss.oracle.com
In-Reply-To: <1207092533.30407.23.camel@dyn9047017100.beaverton.ibm.com>
References: <200802211609.50563.chris.mason@oracle.com>
	 <1207092533.30407.23.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 15:33:33 -0800
Message-Id: <1207092813.30407.25.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-01 at 15:28 -0800, Badari Pulavarty wrote:
> On Thu, 2008-02-21 at 16:09 -0500, Chris Mason wrote:
> > Hello everyone,
> > 
> > Btrfs v0.13 is now available for download from:
> > 
> > http://oss.oracle.com/projects/btrfs/
> 
> Hi Chris,
> 
> I am trying btrfs for the first time. Sorry :(
> Not able to compile btrfs-progs. Where should I
> get this uuid.h from ?


Never mind. Found the answer :)

Thanks,
Badari

> 
> Thanks,
> Badari
> 
> 3b155:~/btrfs-progs-0.13 # make
> ls mkfs.c
> mkfs.c
> gcc -Wp,-MMD,./.mkfs.o.d,-MT,mkfs.o -Wall -fno-strict-aliasing -
> D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -c mkfs.c
> mkfs.c:30:23: uuid/uuid.h: No such file or directory
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

