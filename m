Return-Path: <linux-kernel-owner+w=401wt.eu-S1762836AbXEYNBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762836AbXEYNBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 09:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760526AbXEYNBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 09:01:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:46092 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbXEYNBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 09:01:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=huWUmr7x40RwwpTDWB8B4ZdK5E3hkL8Wb0Wc8uPpag6cQIC1XcoB8SqfxKtdL3wpd7liLvD3pvJ3WwjkFzp3O/Z3RY9TQqdA8g4ZG9aEGmbxF/eUa5YFke/H9AD/jTAOkwjkHgStPIU7fFelyT9+MHZtm/gxR6uxVdFynkCUBW4=
Message-ID: <59ad55d30705250601wfd344b6od7246a830c3372c3@mail.gmail.com>
Date: Fri, 25 May 2007 09:01:30 -0400
From: "=?UTF-8?Q?Kristian_H=C3=B8gsberg?=" <krh@bitplanet.net>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [rfc patch] firewire: prefix modules with firewire- instead of fw-
Cc: linux1394-user@lists.sourceforge.net,
       "=?UTF-8?Q?Kristian_H=C3=B8gsberg?=" <krh@redhat.com>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.68cdceb78a7f6e10@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <tkrat.68cdceb78a7f6e10@s5r6.in-berlin.de>
X-Google-Sender-Auth: 28036a30a7b06903
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Of course everybody immediately associates "fw-" with FireWire, not
> firmware or firewall or whatever.  But "firewire-" has a nice ring to
> it too.

It's fine with me.  I like the less ambiguous names better, and I
don't think the length of the names is a problem.  If you end up
typing the module names too much, you're doing something wrong or
working on the firewire stack, in which case you're screwed anyway :)

Kristian
