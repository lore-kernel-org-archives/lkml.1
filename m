Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbYKZGPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbYKZGPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 01:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbYKZGPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 01:15:33 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:23349 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYKZGPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 01:15:33 -0500
Date: Tue, 25 Nov 2008 22:15:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: Re: mmotm 2008-11-25-17-35 uploaded
Message-Id: <20081125221517.ba02f396.randy.dunlap@oracle.com>
In-Reply-To: <200811260135.mAQ1ZXWf014998@imap1.linux-foundation.org>
References: <200811260135.mAQ1ZXWf014998@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.492CE978.0107:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 17:35:32 -0800 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-11-25-17-35 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/


build-r6513.out:ERROR: "simple_prepare_write" [fs/reiser4/reiser4.ko] undefined!

build-r6514.out:/local/linsrc/tmp/mmotm-2008-1125-1735/drivers/video/backlight/backlight.c:95: warning: format '%d' expects type 'int', but argument 2 has type 'long unsigned int'

---
~Randy
