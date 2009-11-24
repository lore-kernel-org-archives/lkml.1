Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbZKXGo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbZKXGo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 01:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbZKXGo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 01:44:27 -0500
Received: from 70-90-202-97-Albuquerque.hfc.comcastbusiness.net ([70.90.202.97]:49332
	"EHLO deneb.dwf.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZKXGo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 01:44:27 -0500
Message-Id: <200911240644.nAO6iUKv006135@deneb.dwf.com>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3
To: CaT <cat@zip.com.au>
cc: Reg Clemens <reg@dwf.com>, linux-kernel@vger.kernel.org, reg@fw.dwf.com
Subject: Re: Kernel options.
In-reply-to: <20091124055438.GA3639@zip.com.au>
References: <200911240456.nAO4uAlB002080@deneb.dwf.com> 
 <20091124055438.GA3639@zip.com.au>
Comments: In-reply-to CaT <cat@zip.com.au>
   message dated "Tue, 24 Nov 2009 16:54:38 +1100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 23 Nov 2009 23:44:30 -0700
From: Reg Clemens <reg@dwf.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Nov 23, 2009 at 09:56:10PM -0700, Reg Clemens wrote:
> > I have a pre-compiled 64bit kernel from Fedora11, and I can execute
> > both 32 and 64bit executables with it.
> > 
> > I have just built a new kernel (to test some PPS code), and I CANT
> > execute 32bit executables with it.
> > 
> > There must be some option I didnt check.
> > What is it?????
> 
> In the Executable formats menu there is an option (IA32 Emulation) to run
> 32bit binaries in 64bit land.
> 

Bingo.
Thats what I was looking for.
Thanks.
-- 
                                        Reg.Clemens
                                        reg@dwf.com


