Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbZICTkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbZICTkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 15:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbZICTkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 15:40:39 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:54551 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbZICTkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 15:40:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=oiml/rtawURwH3xkVBJ6MK+WXGQE7w6vbPL60Gxz4WupPjo6i5Zl2pnFcWfVZE88CI
         jMbHi8IUYo0vXXpXlwkb0wv1Ijlodh493x9vWUAX+Ix7VHvNfYxkmAlq6CuOORda8MA5
         AUiyAeIXm8s+UqH7PhgrffhEjqgywbTDWA1n4=
MIME-Version: 1.0
In-Reply-To: <20090831074221.GA10263@localhost>
References: <20090831074221.GA10263@localhost>
Date: Thu, 3 Sep 2009 22:40:40 +0300
X-Google-Sender-Auth: 4e29b6cf9236d9f6
Message-ID: <84144f020909031240g3b040eadxd4fd6f662f0b250d@mail.gmail.com>
Subject: Re: [PATCH] slqb: add common slab debug bits
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 10:42 AM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> This is a simple copy&paste from slub.c:
>
> - lockdep annotation
> - might sleep annotation
> - fault injection
>
> CC: Nick Piggin <nickpiggin@yahoo.com.au>
> CC: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Applied, thanks!
