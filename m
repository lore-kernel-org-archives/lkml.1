Return-Path: <linux-kernel-owner+w=401wt.eu-S1765531AbYEFQIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765531AbYEFQIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932219AbYEFQEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:04:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:22194 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbYEFQEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:04:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=v9G2T1IOoaqyMhFrOgnYe8WBRdpSjnsAXhFEhPSuRXoYEh0n48mxQXcjcwPUJv2DDj40uCTyt5A7AMZJ9lwrbGTb49dyVDvEIItfduosmU421bL1x69EvsJoLhEvfK6iEm5387l2LZSJF8Ob7T5z65Hj/loU+zRzPL4TToNXb2g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2,6 patch] make ide-iops.c:SELECT_MASK() static
Date: Tue, 6 May 2008 17:59:03 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080505182139.GD17139@cs181133002.pp.htv.fi>
In-Reply-To: <20080505182139.GD17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805061759.04076.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2008, Adrian Bunk wrote:
> SELECT_MASK() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied
