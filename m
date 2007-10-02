Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbXJBH7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbXJBH7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbXJBH7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:59:37 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:53322 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbXJBH7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:59:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=n7AqkVrh5OT9IDmHgOk1+bpqQa0LDY1BEo8EV6FQAFvY/yV5kN9au3BI6atIFOgc7PIRMdwlwvAa2GXyqZ/BfMSwhxYl+zu/oBYrAScYnrVv+2zrddiKG7wpAqAP6QkiCTw6NvM3O7E/zJyEXWCAfmWz4mayROvOLxg1jmd/knA=
Message-ID: <4701FA63.5080504@gmail.com>
Date: Tue, 02 Oct 2007 09:59:31 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>
Subject: v4l-stk11xx* [Was: -mm merge plans for 2.6.24]
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
In-Reply-To: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2007 11:22 PM, Andrew Morton wrote:
> v4l-stk11xx-add-a-new-webcam-driver.patch
> v4l-stk11xx-use-array_size-in-another-2-cases.patch
> v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
> v4l-stk11xx-add-static-to-tables.patch

No, hold it please, until v4l extension will be developped and bayer->rgb
conversion dismiss from the driver.

> bw-qcam-use-data_reverse-instead-of-manually-poking-the-control-register-fix.patch
> git-dvb-build-fix.patch
> 
>   Send to mchehab

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
