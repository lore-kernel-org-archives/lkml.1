Return-Path: <linux-kernel-owner+w=401wt.eu-S1762380AbZAOKKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762380AbZAOKKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760283AbZAOKKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:10:23 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:57978 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759302AbZAOKKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:10:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KnuzIeb9sutVqz6oRD4zWLiMX8ersUsMmKezEPLA9kJ2t22iH00FlrA4qqXXfL4oM2
         SBfDbtEencEPy4vl63Y2y2sSEwtzZoykprtv4MRyMGRK2x0MWU2di75OleppT88z8NDG
         stRdgX5g9+nrf1Q7FMvm6LIZohTT5nF7qL6q4=
Date: Thu, 15 Jan 2009 10:10:15 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Denys Fedoryschenko <denys@visp.net.lb>
Cc: Badalian Vyacheslav <slavon@bigtelecom.ru>, Chris Caputo <ccaputo@alt.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: deadlocks if use htb
Message-ID: <20090115101015.GD5461@ff.dom.local>
References: <20081010090426.GA6054@ff.dom.local> <496F04AB.2080705@bigtelecom.ru> <20090115095454.GA5461@ff.dom.local> <200901151157.13340.denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901151157.13340.denys@visp.net.lb>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 11:57:13AM +0200, Denys Fedoryschenko wrote:
> I didn't notice a bug, just because all that time i was using it without 
> hrtimers (because of nmi_watchdog).
> 

Denys, maybe I forgot something, but I think you reported this bug
with nmi_watchdog too...

Jarek P.
