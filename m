Return-Path: <linux-kernel-owner+w=401wt.eu-S1764506AbYHDVb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764506AbYHDVb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764291AbYHDVaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:30:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:43501 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764284AbYHDVaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:30:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=T6PWW0ZZcX378AAsn9QOEQsCnkpNYyLXSSRRBfQa+6ed7rWnZ10GUxMTuaLB9+cL73
         Bj7oA8plFfl8IGTeceVmDKJAxOfx/AL+EtSjLm6OesLUcQdTZlcIFr/3u5bOgYTWU74z
         yf5cyTTUyfNrzbCD/pIRKmuvUe1Nti5bG76QY=
Message-ID: <93655eb70808041430u23e45454j23df07e081d25e02@mail.gmail.com>
Date: Tue, 5 Aug 2008 03:00:16 +0530
From: "Satish Eerpini" <eerpini@gmail.com>
To: "Jeff Dike" <jdike@addtoit.com>
Subject: Re: Kernel Installer
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080804140328.GA6683@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <93655eb70808031350q16a5765bk3125e53bd042ba0e@mail.gmail.com>
	 <20080803210051.GF7442@cs181140183.pp.htv.fi>
	 <93655eb70808032045vd6130e9m147d3e3ae8b159b5@mail.gmail.com>
	 <93655eb70808032046y594f38a3u16b7fa2cc6291b1d@mail.gmail.com>
	 <20080804140328.GA6683@c2.user-mode-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yes i have been looking at make -n . but now , collectively parsing
the .config file and the Make files seems to be more useful , ...
what say ?

On Mon, Aug 4, 2008 at 7:33 PM, Jeff Dike <jdike@addtoit.com> wrote:
> On Mon, Aug 04, 2008 at 09:16:52AM +0530, Satish Eerpini wrote:
>> but in the process i am stuck at deciding the no of files that will be
>> compiled , given that representing the entire compilation
>> process as a progress bar , would give a clear idea of " how much is
>> over" and "how much is left" !!!
>
> Look at make -n.  I suspect that its output won't match reality
> perfectly, but it's probably good enough for a progress bar.
>
>                             Jeff
>
> --
> Work email - jdike at linux dot intel dot com
>



-- 
http://satish.playdrupal.com
