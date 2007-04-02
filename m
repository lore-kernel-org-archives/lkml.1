Return-Path: <linux-kernel-owner+w=401wt.eu-S965310AbXDBJmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965310AbXDBJmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 05:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965312AbXDBJmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 05:42:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45531 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965310AbXDBJmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 05:42:42 -0400
Date: Mon, 2 Apr 2007 12:42:40 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Boaz Harrosh <bharrosh@panasas.com>
cc: Jens Axboe <jens.axboe@oracle.com>, Rene Herman <rene.herman@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
In-Reply-To: <4610CDB4.4050708@panasas.com>
Message-ID: <Pine.LNX.4.64.0704021240110.28994@sbz-30.cs.Helsinki.FI>
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk>
 <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com>
 <4610481D.8000102@gmail.com> <46104954.50608@gmail.com>
 <Pine.LNX.4.64.0704020949160.23099@sbz-30.cs.Helsinki.FI>
 <20070402071018.GE11996@kernel.dk> <Pine.LNX.4.64.0704021152280.27165@sbz-30.cs.Helsinki.FI>
 <4610CDB4.4050708@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Boaz Harrosh wrote:
> Why are you using req->buffer in new code.

You did read the patch, right? It's not new code. Feel free to send a 
patch, though. Thanks.

				Pekka
