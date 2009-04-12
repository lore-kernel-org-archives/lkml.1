Return-Path: <linux-kernel-owner+w=401wt.eu-S1757758AbZDLBOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbZDLBOl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 21:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZDLBOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 21:14:32 -0400
Received: from ellpspace.math.ualberta.ca ([129.128.207.67]:36339 "EHLO
	ellpspace.math.ualberta.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470AbZDLBOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 21:14:32 -0400
X-Greylist: delayed 2274 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Apr 2009 21:14:31 EDT
Date: Sat, 11 Apr 2009 18:33:20 -0600
From: Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, linux-kernel@vger.kernel.org,
       tiwai@suse.de, alsa-devel@vger.kernel.org
Subject: Re: General protection fault when unloading snd_hda_intel on
	2.6.30-rc1+
Message-ID: <20090412003320.GA17346@ellpspace.math.ualberta.ca>
References: <20090411193630.GA16968@Pilar.aei.mpg.de> <20090411132033.003c581c@infradead.org> <20090411210336.GA15272@Pilar.aei.mpg.de> <20090411143950.3429ebc0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090411143950.3429ebc0@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 02:39:50PM -0700, Arjan van de Ven wrote:
> 
> so... "dev" is pointing evbit at... 697665646632785 which looks like grabage.

FWIW 697665646632785c decodes in ASCII as "\x2fdevi".

   M.
