Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbYKETfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbYKETfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbYKETfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:35:23 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:13313 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbYKETfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:35:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=et7RyS+Ib+3ouXPaeq6Gs5q/ugy4sCXhuaL2JqPwRQaCU5XehIr985IR9a+Y8Lfwdg
         iqjdeZ3+7+P+M2NDhEjFedqnRfd7Usglb5CjLEzCQpljBqvRv3A/Y2B+RDRcdrQGIwuB
         xiSBJXnZNLyiMNNXGPBSsglWXcGkYhqXEKjB4=
Subject: Re: [PATCH 08/10] parisc: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Kyle McMartin <kyle@infradead.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, grundler <grundler@parisc-linux.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081105193408.GB12146@bombadil.infradead.org>
References: <1225910130.5991.228.camel@brick>
	 <20081105193408.GB12146@bombadil.infradead.org>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 11:35:18 -0800
Message-Id: <1225913718.5991.231.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-05 at 14:34 -0500, Kyle McMartin wrote:
> On Wed, Nov 05, 2008 at 10:35:30AM -0800, Harvey Harrison wrote:
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> Is this dependent on something not yet upstream, or can I just forward
> it along immediately?

It can go in immediately, all prereqs are in mainline.

Harvey

