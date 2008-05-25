Return-Path: <linux-kernel-owner+w=401wt.eu-S1762796AbYEXV6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762796AbYEXV6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761670AbYEXV6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:58:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:3328 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641AbYEXV6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:58:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=jzaIQvIahOMJDZi3/OUH5XqKKnpCcX5ADS+8qY2k3xgFddmOzTPMG/rMUK09+3CIIfA2HQh7HdjdaCIwxR43jW0I1rwPWI3FK02/gbZ14mABg6J/YC3igSM3N3UuTrYBinKYFJdmC3FjQffy7RxwSBEscNvz/BUnkfSE4R1gX9E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC: 2.6 patch] MAINTAINERS: remove SIS 5513 IDE entry
Date: Sun, 25 May 2008 15:11:01 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080519220942.GX17716@cs181133002.pp.htv.fi> <20080519223556.GC17716@cs181133002.pp.htv.fi>
In-Reply-To: <20080519223556.GC17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805251511.01827.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2008, Adrian Bunk wrote:
> On Tue, May 20, 2008 at 01:09:42AM +0300, Adrian Bunk wrote:
> > - maintainer has not been active for years
> > - URLs no longer exist
> > - covered by the IDE SUBSYSTEM entry
> 
> - maintainer email bounces

Lionel did some great work on this driver in the past and it is
a shame that he is no longer active.

If somebody would like to take over maintainership over this driver
(or some other IDE host driver) please just send me a patch adding
yourself to MAINTAINERS file.

> > Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied
