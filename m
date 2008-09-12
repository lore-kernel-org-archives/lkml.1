Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbYILNyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbYILNyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 09:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYILNxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 09:53:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:12253 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666AbYILNxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 09:53:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vtp6JG3faUQcojIiwta+coupn8UO8rbVuL04DJuri44MrByegoO9WAe7SB38V8iKLS
         5zLEe+AeTZ8LveNyPmiHwY4Wr4hl56uYzbrQPZFZizmP+qw4rfZfls9+J+Rf9uSmlcZK
         S6QV3oH4RrHT/46P27vtZuZkgRhfudt4ANtY4=
Message-ID: <8bd0f97a0809120653u73340e0cr48900039d281492@mail.gmail.com>
Date: Fri, 12 Sep 2008 09:53:49 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "sonic zhang" <sonic.adi@gmail.com>
Subject: Re: [PATCH][kgdb][v2] Make mem access function weak in kgdb.c and kgdb.h
Cc: "Jason Wessel" <jason.wessel@windriver.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "kgdb mailing list" <kgdb-bugreport@lists.sourceforge.net>
In-Reply-To: <1221197956.15380.6.camel@eight.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221197956.15380.6.camel@eight.analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 01:39, sonic zhang wrote:

bunch of typos in the comments ...

> + *      kgdb_mem2hex - (optional arch overide) traslate bin to hex chars

override / translate

> + *      Archictures which do not support probe_kernel_(read|write),

Architectures

> + *      can make an alternate implmentation of this function.

implementation

> + *      kgdb_hex2mem - (optional arch overide) traslate hex chars to bin

override / translate

> + *      Archictures which do not support probe_kernel_(read|write),

Architectures

> + *      can make an alternate implmentation of this function.

implementation

> + *      kgdb_ebin2mem - (optional arch overide) Copy the binary array

override

> + *      Archictures which do not support probe_kernel_(read|write),

Architectures

> + *      can make an alternate implmentation of this function.

implementation

> + *      This function safely copys binary array into memory

copies
-mike
