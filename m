Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbYIRXy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbYIRXy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 19:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbYIRXxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 19:53:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:63767 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776AbYIRXxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 19:53:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=l6HpRy7OkLkbguvoQwLuQcWtIcxHPMjGLXnsSnY682itRlWbOnTtNWGks6r0cRpT8u
         YfeDq3Fpjek33oC5xj0O1TiOFy9m2uohPCAZVA2Y3oG67N5ZM3hOyNgSKZBZxiE8l2+F
         If4T1JSTuyBzkOOxwEjXR9z87pG4E/eSyt0Hc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH 4/4 v2] Add documentation for hard disk shock protection interface
Date: Thu, 18 Sep 2008 16:28:33 -0700
User-Agent: KMail/1.9.9
Cc: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <87d4j2n3dn.fsf@denkblock.local> <20080917163145.9870.8575.stgit@denkblock.local>
In-Reply-To: <20080917163145.9870.8575.stgit@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809181628.34569.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2008 09:40:06 Elias Oltmanns wrote:
> Put some information (and pointers to more) into the kernel's doc tree,
> describing briefly the interface to the kernel's disk head unloading
> facility. Information about how to set up a complete shock protection
> system under GNU/Linux can be found on the web and is referenced
> accordingly.
> 
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>

applied
