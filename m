Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbXFITka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbXFITka (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759082AbXFITkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:40:23 -0400
Received: from pop-sarus.atl.sa.earthlink.net ([207.69.195.72]:37346 "EHLO
	pop-sarus.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759064AbXFITkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:40:22 -0400
From: Rich Chase <rac47.02@engalumni.colostate.edu>
Organization: Independent Thinkers R Us
To: linux-kernel@vger.kernel.org
Subject: Re: missing elfconfig.h
Date: Sat, 9 Jun 2007 12:38:28 -0400
User-Agent: KMail/1.9.4
References: <200706080908.37044.rac47.02@engalumni.colostate.edu> <Pine.LNX.4.64.0706090952250.4353@fbirervta.pbzchgretzou.qr> <20070609085309.GB30611@uranus.ravnborg.org>
In-Reply-To: <20070609085309.GB30611@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706091238.28801.rac47.02@engalumni.colostate.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned,

> It depnes on the module. If the module uses
> MODVERSIONIGN a full build is needed.

This is what I did. However, the include file is 
missing. Do sourcefiles (other than config.h) get 
created at compile time?

Thanks,
Rich
