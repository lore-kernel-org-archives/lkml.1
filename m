Return-Path: <linux-kernel-owner+w=401wt.eu-S965110AbXHLUDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965110AbXHLUDm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757012AbXHLUDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:03:34 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:51968
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754590AbXHLUDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:03:34 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/5] Add some missing Documentation/*/00-INDEX files
Date: Sun, 12 Aug 2007 15:03:30 -0500
User-Agent: KMail/1.9.6
Cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200708120045.03032.jesper.juhl@gmail.com> <46BF01A5.9060003@s5r6.in-berlin.de>
In-Reply-To: <46BF01A5.9060003@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708121503.30631.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 August 2007 7:48:37 am Stefan Richter wrote:
> Isn't it with 00-INDEX just like with the "Last Updated:" footers in
> documentation texts?
>
> They are metadata which will be almost always out of date.

If nothing is using them, they'll bit-rot, yes.  Way of the world.  But I've 
found a use for them.  Therefore, I'm interested in getting them up to date 
and then keeping them there.  I already wrote an automatic checker to tell me 
how they differ from reality, which is half the battle.  (It won't help if 
the file contents change so much the description needs to be updated, but 
that's not a common event.)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
