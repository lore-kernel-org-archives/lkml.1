Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbZJ1Xg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbZJ1Xg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 19:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbZJ1Xgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 19:36:55 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49862 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbZJ1Xgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 19:36:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BHlAPalWQUyW+4VJgUkhXcQChB2ynt95L8yfvji3ZaLfvgDCOngSYHp6sDuXKX+PTC
         wWWgls8PNZMG8fLW9FJ3kz4SiEbl0XvkXwriL2kVu+95NNSy5F0RfROHcmTkgdle98YN
         KMlRSq9HML4fAlbTfFo7Y/BtghXK9AJyKqVy8=
Date: Thu, 29 Oct 2009 00:36:53 +0100
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #14265] ifconfig: page allocation failure. order:5,
	mode:0x8020 w/ e100
Message-ID: <20091028233653.GA2206@bizet.domek.prywatny>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera> <vX3ILojF2dJ.A.P8G.Aff5KB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vX3ILojF2dJ.A.P8G.Aff5KB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 08:31:54PM +0100, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14265
> Subject		: ifconfig: page allocation failure. order:5, mode:0x8020 w/ e100
> Submitter	: Karol Lewandowski <karol.k.lewandowski@gmail.com>
> Date		: 2009-09-15 12:05 (42 days old)
> References	: http://marc.info/?l=linux-kernel&m=125301636509517&w=4

Bug is still present in 2.6.32-rc5.

(I'm currently testing Mel's patches.)

Thanks.
