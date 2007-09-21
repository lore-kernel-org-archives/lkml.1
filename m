Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbXIULDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbXIULDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 07:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbXIULDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 07:03:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:24436 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbXIULDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 07:03:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=jZcwa2C+yEFjWluo9UEIuhlEkn84dN8cxqipdsXPBlJGD/DN1NeDMb7Tvzc8qLOdp9V8j7m0Xo0uyB0nejhV9UWgNg/OYb9HUpUvHyB8lsXlEVlPpNra//S88T0dRTi5eogv+JaeTVxY5itLBp5lHv1LZPVo4mDt6XHrmXUJKr4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 2/2] bnx2: move gzip unpacker to zlib
Date: Fri, 21 Sep 2007 12:03:35 +0100
User-Agent: KMail/1.9.1
Cc: Michael Chan <mchan@broadcom.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <200709211201.24475.vda.linux@googlemail.com>
In-Reply-To: <200709211201.24475.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211203.35956.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 September 2007 12:01, Denys Vlasenko wrote:
> I will move this code
> out of the driver and into zlib in follow-on patch.

No, I won't. I accidentally attached both patches to first email,
you can find it there. Sorry.
--
vda
