Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbYFDMuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbYFDMuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbYFDMuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:50:02 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:50696 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYFDMuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WvtF4vi/ci+nvM+XOwnuUVj1FZFD89OUAGTIyOqM+jra86W762Z27eFRavBJQFnYQM
         xLiGDDAR4zZlLgYLxFqJTldbrFmkLwVubvNm/lWceuUJP052Fo/KJ1tnGgOf5RH3OZlQ
         QxFfX0EJDa4oB4eNXk2cV4ZMde0Jlo7UmAFig=
Message-ID: <e2e108260806040549p11117410x192d1020adb885c7@mail.gmail.com>
Date: Wed, 4 Jun 2008 14:49:58 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: Lkm <lkm@lea-linux.com>
Subject: Re: PROBLEM: Hardware clock instable
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200806041402.39515.lkm@lea-linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806041402.39515.lkm@lea-linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 2:02 PM, Lkm <lkm@lea-linux.com> wrote:
>
> i work in a web hosting compagny. We have a strange problem on many servers.
> The hardware clock of several server is totaly instable. This happen on many
> server, not all.

Which messages are logged by the NTP daemon during the first 24 hours
after it has been started ? On Debian systems you can install NTP by
running apt-get install ntp.

Bart.
