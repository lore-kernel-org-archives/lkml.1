Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbZGBA2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbZGBA2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 20:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZGBA1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 20:27:53 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:51409 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZGBA1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 20:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=E1/NpCYm9gtjZTpsik9+O9AwjSpDqtUnsG0OPYc/ywJdMoMG1GEnQ+lf70hMXK4puN
         p86Cnk9wH6ySiTH1hghq/8kZDe7kL4CY7CGcoGL79FHzQgfFZAtLUXUNq/dL/5ESwoRM
         8qwBdJKTBnCcbjSeK+TLoD+GH4MQx6PGZrDB4=
MIME-Version: 1.0
In-Reply-To: <03676ce0e272d44d1d4ea19639b28afb994c65eb.1246173680.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
	 <03676ce0e272d44d1d4ea19639b28afb994c65eb.1246173680.git.joe@perches.com>
Date: Wed, 1 Jul 2009 17:27:55 -0700
X-Google-Sender-Auth: dad1b958bbc46308
Message-ID: <e9c3a7c20907011727y2263e3f0k59b7ad497cd67274@mail.gmail.com>
Subject: Re: [PATCH 15/62] drivers/dma/fsldma.c: Remove unnecessary semicolons
From: Dan Williams <dan.j.williams@intel.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Zhang Wei <zw@zh-kernel.org>, Li Yang <leoli@freescale.com>,
       linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 9:26 AM, Joe Perches<joe@perches.com> wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/dma/fsldma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied 15 and 16.

Thanks,
Dan
