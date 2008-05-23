Return-Path: <linux-kernel-owner+w=401wt.eu-S1764497AbYEWDhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764497AbYEWDhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 23:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759807AbYEWDhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 23:37:21 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:23833 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755687AbYEWDhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 23:37:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=38KZXnfnhAk1JJMk1tR39U9BnyWw5leKhtLipmLYuXlrcr+9VXQStifnj4EbVuS38ZMHDIrEtVtIMDFJuy0GtxwDOyQIYRlid1c4fGe8oCKvwABC+ErIs28mO4raJ/AeTQMpudLJd6+qBShEar7jOgqYYY2UwKYfj0mnOGRUnkQ=  ;
X-YMail-OSG: p.ORmdUVM1mdiDBfySD3cohOwxDCR.4qmaF1_c9PbG3HSFUz6X.Ju4wXs76fQC5Z1ADJDbrVB9W4ulmREtEVmMB7ifhKlfMslu4kVGuSt0nIz1lJCXsR_IZOeXIqc.8jHgU-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Fabio Tosetto <tosettofabio83@libero.it>
Subject: Re: SD-MMC over SPI on PSC6
Date: Thu, 22 May 2008 19:02:45 -0700
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, avorontsov@ru.mvista.com, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       galak@kernel.crashing.org, garyj@denx.de, g.liakhovetski@gmx.de
References: <48354E2B.8010003@libero.it>
In-Reply-To: <48354E2B.8010003@libero.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805221902.45578.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2008, Fabio Tosetto wrote:
> <*> MMC host test driver

Unwise unless you really want to trash every MMC or SD card
you insert ...


You might consider not crossposting to such a large proportion
of the free world, by the way.
