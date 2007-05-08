Return-Path: <linux-kernel-owner+w=401wt.eu-S934810AbXEHJrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934810AbXEHJrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934653AbXEHJrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:47:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:20585 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934650AbXEHJrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:47:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=p1pJ66Adax4nVonth1E5NzhznCNMw52pxwvG4KrS7+vOlduANV4wj9pnhelpQC6bOOUpwsFg7+xDyFwFvIm41/fjm39u2NEFhd5nDqfg41oKNxQ5tPNMPwGSKZ6b7E7kl/H1c4YAEAdjWCIkTT8yk/Z06ffU9k4O0p0TtFLZhgc=
Message-ID: <46404698.6020804@gmail.com>
Date: Tue, 08 May 2007 11:44:56 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New Mitsumi legacy CD-ROM driver
References: <464045F0.3040906@gmail.com>
In-Reply-To: <464045F0.3040906@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2007 11:42 AM, Rene Herman wrote:

> This is (the start of) a new driver for the legacy Mitsumi CD-ROM 
> (LU-00xS and FX-001x) drives that used to be supported by 
> drivers/cdrom/mcd(x).c, a driver that hasn't worked for a long time.

Forgot:

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Rene Herman <rene.herman@gmail.com>

Rene.
