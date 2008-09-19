Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbYISIdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbYISIdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 04:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbYISIdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 04:33:33 -0400
Received: from ryu.zarb.org ([212.85.158.22]:34878 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbYISIdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 04:33:32 -0400
Subject: Re: edd breaking vesafb
From: Pascal Terjan <pterjan@mandriva.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Frederic Crozat <fcrozat@mandriva.com>
In-Reply-To: <48D2A15D.6010800@zytor.com>
References: <1221751035.26693.8.camel@plop>  <48D2811B.8090602@zytor.com>
	 <1221757806.26693.14.camel@plop>  <48D2A15D.6010800@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Mandriva
Date: Fri, 19 Sep 2008 10:33:28 +0200
Message-Id: <1221813208.4894.1.camel@plop>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.92-1mdv2009.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 18 septembre 2008 à 11:43 -0700, H. Peter Anvin a écrit :
> Pascal Terjan wrote:
> > 
> > No it does not help
> > 
> 
> What happens with edd=off or edd=skipmbr?
> 

Here is the answer from original reporter, adding him in Cc

edd=off : vesafb works properly
edd=skipmbr : vesafb is not initialized (just like edd=on)
edd=on : vesafb is not initialized 

