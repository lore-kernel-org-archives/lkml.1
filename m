Return-Path: <linux-kernel-owner+w=401wt.eu-S1422744AbXDXQeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422744AbXDXQeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 12:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422746AbXDXQeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 12:34:09 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:19689 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422744AbXDXQeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 12:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PSfJcJfy8xYzeu0Aww0MMmiEHieNf7wcH2jUkJpzmGOkRGpMs4dkrBwUw5Nr7NjJ6uxmCUXYhUJJSgLR+d0guE/uqcKvfct2V6Db57TO5nCUPJKINdACMXkqUP3wvwbVkpaW0gxYpQDNfrY0ArWJ9fJ8gfNgbEmqJp01q0/szWA=
Message-ID: <462E3177.4000901@gmail.com>
Date: Wed, 25 Apr 2007 01:33:59 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Vincent Vanackere <vincent.vanackere@gmail.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [OOPS 2.6.21-rc7-mm1] kernel BUG at fs/sysfs/inode.c:272 (sysfs_drop_dentry)
References: <65258a580704240820lbee4944t1adef1aeb92394ce@mail.gmail.com>
In-Reply-To: <65258a580704240820lbee4944t1adef1aeb92394ce@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vincent Vanackere wrote:
> Hi,
> 
> I'm getting the following oops at boot with the latest -mm kernel :
> ---------------------------------------------------------------
> kernel BUG at fs/sysfs/inode.c:272

Known problem.  Working on it.  Thanks.

-- 
tejun
