Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbXIBWQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbXIBWQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 18:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbXIBWPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 18:15:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:37274 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbXIBWPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 18:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XYx9xUU/vXjjGOORLK8VwhvDxzMSmFqc6wLx8p1T+to8UpckYSqRR94vtY0EveQ/EjJxzcRWEsQh/yrMzIQwPLmcA3RmXhz/O4ak3Hjp1dmnc62YDF30UJAOdpykfa/UAcAPcEOOXuIhBgYrSJCFMC8UPutcKle07Z2NS+hLJxk=
Message-ID: <6bffcb0e0709021515v586f078cjce04f877e2f27aa2@mail.gmail.com>
Date: Mon, 3 Sep 2007 00:15:46 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Karl Meyer" <adhocrocker@gmail.com>
Subject: Re: PROBLEM: 2.6.23-rc "NETDEV WATCHDOG: eth0: transmit timed out"
Cc: "Francois Romieu" <romieu@fr.zoreil.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <be1b757c0709011224tafebaaby697d03ab5377e20f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <be1b757c0708130435y689b9dd8raf9ac9f9c0fcc976@mail.gmail.com>
	 <20070813165821.GA19356@electric-eye.fr.zoreil.com>
	 <be1b757c0708131027v5c57822as2d9bd3190fd19b71@mail.gmail.com>
	 <20070814070901.GA14693@electric-eye.fr.zoreil.com>
	 <be1b757c0708141425qd887581n3922702b84a21758@mail.gmail.com>
	 <20070814224629.GB3495@electric-eye.fr.zoreil.com>
	 <20070816141122.GA6625@electric-eye.fr.zoreil.com>
	 <be1b757c0709011224tafebaaby697d03ab5377e20f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/09/07, Karl Meyer <adhocrocker@gmail.com> wrote:
> This is what happened today:
>
> Sep  1 21:08:01 frege NETDEV WATCHDOG: eth0: transmit timed out
> frege ~ # uname -r
> 2.6.22.5-cfs-v20.5

Can you reproduce this on 2.6.22 (not 2.6.22.x - it might be a -stable
regression)?

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
