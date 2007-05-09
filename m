Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbXEIVKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbXEIVKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759231AbXEIVJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:09:52 -0400
Received: from web52906.mail.re2.yahoo.com ([206.190.49.16]:33342 "HELO
	web52906.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758992AbXEIVJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:09:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=RoneMfxajFa1RhvWSkEjKwSMJXxePMeSKX02JDP893eEOtxoYiRyRT4MfOASenmG/iw3NLFRwJXw8wGcdDB9z0oyE3yfrktmsrgWIPmyv9xZ8Nrbc3kmFpdGPRSdgBtHDCfI8q+aJhw37lgsZQLan6mDZyVPxQf3hZayQrUIZpE=;
X-YMail-OSG: W9uyH8MVM1kITrDmcRGpt7qaiyhiF0AkqOm57u96xkDRp3WrRtLEEllgtFcSlTEeyw--
Date: Wed, 9 May 2007 22:09:50 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [linux-usb-devel] Bug creating USB endpoints in 2.6.20.x (kernel bug 8198)
To: Tejun Heo <htejun@gmail.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       maneesh@in.ibm.com,
       "cornelia.huck@de.ibm.com >> Cornelia Huck" 
	<cornelia.huck@de.ibm.com>
In-Reply-To: <4641E1AF.9060201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <25138.46572.qm@web52906.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Tejun Heo <htejun@gmail.com> wrote:
> Looking at the code, class
> device is already doing it that way, so here's the full-assed fix.
> Chris, can you please test the attached patch?

Tejun,

So far so good; my 2.6.20.11+patch kernel hasn't oopsed yet. I'm going to start using this kernel
as my default boot and see how it goes.

Cheers,
Chris


      ___________________________________________________________
Yahoo! Answers - Got a question? Someone out there knows the answer. Try it
now.
http://uk.answers.yahoo.com/
