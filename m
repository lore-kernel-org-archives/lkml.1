Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbZENQu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbZENQu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 12:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbZENQuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 12:50:13 -0400
Received: from plexity.net ([206.123.115.38]:52540 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbZENQuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 12:50:12 -0400
Date: Thu, 14 May 2009 16:49:15 +0000
From: Deepak Saxena <dsaxena@plexity.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alessandro Rubini <rubini@vision.unipv.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] psmouse:  ESD workaround fix for OLPC XO touchpad
Message-ID: <20090514164915.GA26267@plexity.net>
Reply-To: dsaxena@plexity.net
References: <20090514011603.GA12494@plexity.net> <20090514022126.GA9461@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090514022126.GA9461@dtor-d630.eng.vmware.com>
Organization: Plexity, LLC
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 13 2009, at 19:21, Dmitry Torokhov was caught saying:
> Hi Deepak,
> 
> On Thu, May 14, 2009 at 01:16:03AM +0000, Deepak Saxena wrote:
> > This issue was found during testing back in 2007, before I
> > was involved, and the fix has been carried in the OLPC tree 
> > since then. Not sure how this would affect other systems so 
> > wondering if we should wrap this specific check around 
> > '#ifdef OLPC'?
> > 
> 
> *sigh* Why can't we just implement standard?

our jobs as software engineers would be far far more boring in that case ;)

-- 
In the end, they will not say, "those were dark times,"  they will ask
"why were their poets silent?" - Bertold Brecht

