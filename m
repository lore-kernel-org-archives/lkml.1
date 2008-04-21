Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbYDULID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbYDULID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 07:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbYDULHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 07:07:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:37993 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbYDULHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 07:07:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m4YCZAe61kIe7KpguO77J8Tt0Z36hyFhFwwtG8ZyET3TDu2wcicjziE1wgw8AyNfkp9NZG04BccnT14+J/EKMiiNy51ulvnK189QQSOc2gjo1KdUJwYaOLlpUf3p0hRWoENFuFuvEFRc11aZ1H0miebeuqjY4eT6zRk7N20WM+Q=
Message-ID: <e2e108260804210407j7262c814y7bc67f5387822273@mail.gmail.com>
Date: Mon, 21 Apr 2008 13:07:51 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Matthias Andersson" <matthias.andersson@gmail.com>
Subject: Re: Kernel panic
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9a5eeacd0804210356t2b84bb40t7a266467c3699bd9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a5eeacd0804210350v79db27f0of73a29c55e2b7311@mail.gmail.com>
	 <9a5eeacd0804210356t2b84bb40t7a266467c3699bd9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 12:56 PM, Matthias Andersson
<matthias.andersson@gmail.com> wrote:
>  I upgraded to Ubuntu 8.04 (Hardy Heron) four days ago and with it the
>  2.6.24-16 kernel.
>  The kernel worked fine until yesterday when I booted up the machine I
>  was greeted by the following error message:
>
>   /init: ./34: Can't open /scripts/functions
>  [   20.587228] kernel panic - not syncing: attempted to kill init!
>
>  What could have caused this failiure?
>  There were some upgrades installed before the final shutdown of the
>  system (prior to the kernel panic) but nothing system-critical.

Hello Matthias,

This is an Ubuntu 8.04 issue, not a kernel issue. Please post this
issue in an Ubuntu forum.

Bart.
