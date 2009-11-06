Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbZKFRO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbZKFRO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 12:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759445AbZKFRO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 12:14:56 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:58534 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759377AbZKFROz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 12:14:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=d0s22HA2YArAtbe5LCIJ+Tz7Bz6Fpb4BOOkTV++2z5APHg+0/piR5l7fGZYz9n90/K
         vIPPpJkAH7vP+2zHVryd/ljQlunVmDx4HSG2t/vWisqkhp6ryt/ftRDybiQnDSOiHk9r
         l7tVD0S4vyAaiO63rma1K+nEu9V+clEPWl8T4=
MIME-Version: 1.0
In-Reply-To: <4AF452B8.7080306@googlemail.com>
References: <43e72e890911051654i19c18bf3nd397662ed79712c4@mail.gmail.com> 
	<1257484663.2873.622.camel@calx> <43e72e890911060832k1b831f32w93357c71b370e71c@mail.gmail.com> 
	<4AF452B8.7080306@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 6 Nov 2009 09:14:40 -0800
Message-ID: <43e72e890911060914i6233b71dgd68e228074869096@mail.gmail.com>
Subject: Re: Using netconsole and getting double prints
To: Andre Naujoks <nautsch2@googlemail.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 6, 2009 at 8:45 AM, Andre Naujoks <nautsch2@googlemail.com> wrote:

> I think the intention behind this is for you to check if they are double
> prints on your end or double sends on the other end.

Ah yeah, good point :)
