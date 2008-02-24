Return-Path: <linux-kernel-owner+w=401wt.eu-S1759188AbYBXQci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188AbYBXQci (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 11:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYBXQcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 11:32:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:31798 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbYBXQcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 11:32:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=QacBNeBsPOT7tr7emLUy+uAzt6csjt4ykN737eb2gXIINYtzB8/0IfqFrV9CgVEVWXvUdeZSXyNM4cEd5NwGxQapU8I/K68g+ge1DJZdE29tC7QZ0uZyntGCN8e0m6Oizn7Xm7/DWev1IBN4tq15KGG7FbCLlOQfN4d/avhCiwM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Subject: Re: [PATCH 00/10] IDE: Coding Style Fixes
Date: Sun, 24 Feb 2008 16:49:51 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>
References: <20080223150436.6c09ce54@paolo-desktop>
In-Reply-To: <20080223150436.6c09ce54@paolo-desktop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802241649.51627.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 23 February 2008, Paolo Ciarrocchi wrote:
> Hi Bartlomiej,
> The following 10 patches remove a huge number of errors and warnings
> reported by checkpatch.pl from the IDE subsystem.

[...]

Thanks!

I applied everything (patch #8 with fixes based on comments from
Adrian & Cyrill + patches #1/2/4/5 also with some improvements)
and verified that md5sums for the resulting binary files remain
the same.

Bart
