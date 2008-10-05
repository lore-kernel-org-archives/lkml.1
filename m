Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbYJEVky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbYJEVky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 17:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYJEVkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 17:40:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:14205 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbYJEVko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 17:40:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bnx6NWK4p58zquRbVBLgBy5Z043ppal5tQHhdA3FtAdjKKdgnaKkgTerHcQTwL6mFA
         EwpvsMKzqxk2YpWTbiNcFxiOioilCRnT5IunZi5K3mBoHJqtR9t2PBWmj6dcHoeAivNf
         9yqpEeReOQQEaX6D1im0tLueWBwRxvfBCa3Lk=
Message-ID: <f7848160810051440k2f7a4717mc0a3b54e7576d6e6@mail.gmail.com>
Date: Sun, 5 Oct 2008 17:40:43 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: 2.6.27-rc8+ - first impressions
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <20081005211748.GA11576@amd.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081005183603.GA3263@amd.corenet.prv>
	 <200810052059.49942.rjw@sisk.pl>
	 <20081005190658.GC3263@amd.corenet.prv>
	 <200810052119.13881.rjw@sisk.pl>
	 <20081005211748.GA11576@amd.corenet.prv>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 5, 2008 at 5:18 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:

>        Vendor: Hewlett-Packard
>        Version: 68DTT Ver. F.0D
>        Release Date: 11/22/2005

Not sure if the HPET related things are better in the latest release
of the 6915 BIOS - which is F12 [*].
But may be worth trying?

[*'] http://h20000.www2.hp.com/bizsupport/TechSupport/SoftwareDescription.jsp?lang=en&cc=in&prodTypeId=321957&prodSeriesId=471752&swItem=ob-59364-1&prodNameId=471755&swEnvOID=1093&swLang=8&taskId=135&mode=4&idx=2

Parag
