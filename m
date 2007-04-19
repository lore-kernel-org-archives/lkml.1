Return-Path: <linux-kernel-owner+w=401wt.eu-S1766952AbXDSTYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766952AbXDSTYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766958AbXDSTYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:24:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:15711 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766952AbXDSTYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:24:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eA1y/xmk9rtx12V8CcPHKM7TlZ21rr9sE+BD3f9GbAOaS9pIpZrn6AdgG2Yev88LTyyuDOWv+kACDCxJog7jkJ4wZZmGhy9WqqyjczI5on7ZoGiJ07ZvOsJz84GXF+ciq/62xka3ww8RVajGfxMrIvDvbfJn/URW5MqqdmmBUuc=
Message-ID: <9c21eeae0704191224g104f4an96b330c6b77c29a7@mail.gmail.com>
Date: Thu, 19 Apr 2007 12:24:31 -0700
From: "David Brown" <dmlb2000@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [kvm-devel] [GIT PULL] kvm oops fix
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4627BE6B.8030006@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1176997839110-git-send-email-avi@qumranet.com>
	 <alpine.LFD.0.98.0704190949580.9964@woody.linux-foundation.org>
	 <4627BE6B.8030006@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What is the easiest way to completely undo a pull, reverting the branch
> to the HEAD present before the pull?
>

If the pull doesn't merge successfully then usually doing a `git-reset
--hard` will blow everything away back to normal, but Linus may do
different things.

- David Brown
