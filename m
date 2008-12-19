Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbYLSUGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbYLSUGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbYLSUGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:06:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:30685 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYLSUGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:06:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=m2KbS0jPFSE7x3SNkF/wjW9A0zetiMAEIxXeiHutw4ke8VUpKIMg/vjyoTFiL0b2w4
         21SG8zsxD7vf8XepW/0H9hg38c5RmrLTkVhe93sOXgIaoq/VVpLpf0tcUV/xIMS+CekY
         15m/aeEDPjr/KkcXdqc8FsukbaFobMkEc8IIs=
Message-ID: <84144f020812191205h733486eap8be6be8cac8ea3fd@mail.gmail.com>
Date: Fri, 19 Dec 2008 22:05:59 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Catalin Marinas" <catalin.marinas@arm.com>
Subject: Re: [PATCH 05/14] kmemleak: Add the slub memory allocation/freeing hooks
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081219181324.7778.98870.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	 <20081219181324.7778.98870.stgit@pc1117.cambridge.arm.com>
X-Google-Sender-Auth: 62a7eb0531580817
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 8:13 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> This patch adds the callbacks to kmemleak_(alloc|free) functions from the
> slub allocator.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
