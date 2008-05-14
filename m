Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbYENRAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbYENRAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYENRAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:00:06 -0400
Received: from compunauta.com ([69.36.170.169]:34267 "EHLO compunauta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbYENRAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:00:05 -0400
X-Greylist: delayed 887 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 May 2008 13:00:05 EDT
From: Gustavo Guillermo Perez <gustavo@compunauta.com>
Organization: www.compunauta.com
To: linux-kernel@vger.kernel.org
Subject: Re: [patch 20/37] {nfnetlink, ip, ip6}_queue: fix skb_over_panic when enlarging packets
Date: Wed, 14 May 2008 11:45:09 -0500
User-Agent: KMail/1.9.7
References: <20080513200453.064446337@mini.kroah.org> <877idxdb04.fsf@natisbad.org> <20080513220627.GA18320@suse.de>
In-Reply-To: <20080513220627.GA18320@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805141145.09563.gustavo@compunauta.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Martes, 13 de Mayo de 2008, Greg KH escribió:
> On Wed, May 14, 2008 at 01:45:15AM +0200, Arnaud Ebalard wrote:
> > Hi,
> >
> > Greg KH <gregkh@suse.de> writes:
> > > 2.6.25-stable review patch.  If anyone has any objections, please let
> > > us know.
> >
> > Sorry for the noise, but for those who missed one of the latest post on
> > the topic on netdev, I should add that the bug is also in 2.6.24.4 (even
> > if it's probably too late for that poor guy :-( ).
>
> Sorry, yes, we are no longer doing 2.6.24-stable releases.
the fix will be available in 2.6.25.4 ?


-- 
Gustavo Guillermo Pérez
Compunauta uLinux
www.compunauta.com
