Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbZLAPFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbZLAPFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 10:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZLAPFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 10:05:49 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:41446 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbZLAPFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 10:05:48 -0500
Subject: Re: virtio: Add memory statistics reporting to the balloon driver
 (V4)
From: Adam Litke <agl@us.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <anthony@codemonkey.ws>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <4B152EA4.7080207@redhat.com>
References: <1259597655.30369.2.camel@aglitke> <4B152EA4.7080207@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 01 Dec 2009 09:05:05 -0600
Message-ID: <1259679905.2816.5.camel@aglitke>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 16:56 +0200, Avi Kivity wrote:
> What about a spec update?  Did that happen and I just missed it?

Yes it did.  I forgot to update this patch leader note with the link:
http://ozlabs.org/~rusty/virtio-spec/virtio-spec-0.8.2.pdf


-- 
Thanks,
Adam

