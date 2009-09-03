Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbZICGDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbZICGDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 02:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbZICGDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 02:03:09 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:37621 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbZICGDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 02:03:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=VyZ4cFg0dt7JGJCO1ubilvECkG7PXcn5Ql7ytrLsOCsg3+6jZs1KYTp59HHpGrpfbj
         pN8tY6sYrlU2CB1JFpw46YQlhfyMptmOFpb0abPYGfhcRPtHHs7bpvtaN0sja/DUQ8rm
         DP/fA2x47dYou6U52PksnSaHqQis1UgEaJoks=
MIME-Version: 1.0
In-Reply-To: <1251942059-21448-4-git-send-email-lrodriguez@atheros.com>
References: <1251942059-21448-1-git-send-email-lrodriguez@atheros.com>
	 <1251942059-21448-4-git-send-email-lrodriguez@atheros.com>
Date: Thu, 3 Sep 2009 09:03:09 +0300
X-Google-Sender-Auth: dd2a446eae6f2abd
Message-ID: <84144f020909022303m4990d2d2vf5b0ee83c2d45a1c@mail.gmail.com>
Subject: Re: [PATCH 3/5] kmemleak: move common painting code together
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 4:40 AM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
> When painting grey or black we do the same thing, bring
> this together into a helper and identify coloring grey or
> black explicitly with defines. This makes this a little
> easier to read.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
